//
//  PathTextContainer.m
//  CircleLayout
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PathTextContainer.h"

@interface PathTextContainer ()
@property (nonatomic, readwrite, strong) NSMutableData *inclusionPathBitmap;
@property (nonatomic, readwrite, assign) CGSize inclusionPathBitmapSize;
@property (nonatomic, readwrite, assign) CGRect inclusionPathBoundingBox;

@end
@implementation PathTextContainer

- (CGRect)clipRectToInclusionPaths:(CGRect)rect remainingRect:(CGRect *)remainingRect {
  const uint8_t *bits = self.inclusionPathBitmap.bytes;

  NSUInteger minX = CGRectGetMinX(rect);
  NSUInteger minY = CGRectGetMinY(rect);
  NSUInteger maxX = CGRectGetMaxX(rect);
  NSUInteger maxY = CGRectGetMaxY(rect);
  NSUInteger width = (NSUInteger)self.inclusionPathBitmapSize.width;

  BOOL foundStart = NO;
  NSRange range = NSMakeRange(0, 0);
  NSUInteger column = minX;
  for (; column < maxX; ++column) {
    BOOL isGoodColumn = YES;
    for (NSUInteger y = minY; y < maxY; ++y) {
      if (bits[y * width + column] < 128) {
        isGoodColumn = NO;
        break;
      }
    }

    if (isGoodColumn && ! foundStart) {
      foundStart = YES;
      range.location = column;
    }
    else if (!isGoodColumn && foundStart) {
      break;
    }
  }

  if (foundStart) {
    // x is 1 past the last full-height column
    range.length = column - range.location - 1;

    if (remainingRect) {
      // Find next open area
      column++;
      NSUInteger nextOpenColumn = NSNotFound;
      for (; column < maxX; ++column) {
        BOOL isGoodColumn = YES;
        for (NSUInteger y = minY; y < maxY; ++y) {
          if (bits[y * width + column] < 128) {
            isGoodColumn = NO;
            break;
          }
        }

        if (isGoodColumn) {
          nextOpenColumn = column;
          break;
        }
      }

      if (nextOpenColumn != NSNotFound) {
        CGRect newRemainder = CGRectMake(column, rect.origin.y,
                                        ceilf(CGRectGetMaxX(rect) - NSMaxRange(range) - 1),
                                        CGRectGetHeight(rect));
        if (! CGRectIsEmpty(newRemainder)) {
          if (! CGRectIsEmpty(*remainingRect)) {
            newRemainder = CGRectUnion(newRemainder, *remainingRect);
          }
          *remainingRect = newRemainder;
        }
      }
    }
  }

  CGRect clipRect =
  CGRectMake(range.location, rect.origin.y,
             range.length, rect.size.height);
  return clipRect;
}

- (void)setInclusionPaths:(NSArray *)inclusionPaths {
  CGMutablePathRef path = CGPathCreateMutable();
  for (UIBezierPath *inclusionPath in inclusionPaths) {
    CGPathAddPath(path, NULL, inclusionPath.CGPath);
  }

  CGRect boundingBox = CGPathGetPathBoundingBox(path);
  self.inclusionPathBoundingBox = boundingBox;
  CGRect bounds = CGRectMake(0, 0, CGRectGetMaxX(boundingBox), CGRectGetMaxY(boundingBox));

  size_t width = ceilf(bounds.size.width);
  size_t height = ceilf(bounds.size.height);
  self.inclusionPathBitmapSize = CGSizeMake(width, height);
  self.inclusionPathBitmap = [NSMutableData dataWithLength:width * height];
  uint8_t *bits = self.inclusionPathBitmap.mutableBytes;
  CGContextRef bitmapContext =
  CGBitmapContextCreate(bits,
                        width,
                        height,
                        sizeof(*bits) * 8,
                        width,
                        NULL,
                        (CGBitmapInfo)kCGImageAlphaOnly);
  CGContextSetAllowsAntialiasing(bitmapContext, NO);
  CGContextAddPath(bitmapContext, path);
  CGContextFillPath(bitmapContext);
  CGPathRelease(path);
  CGContextRelease(bitmapContext);
}

- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect
                                  atIndex:(NSUInteger)characterIndex
                         writingDirection:(NSWritingDirection)baseWritingDirection
                            remainingRect:(CGRect *)remainingRect {
  CGRect rect = [super lineFragmentRectForProposedRect:proposedRect
                                               atIndex:characterIndex
                                      writingDirection:baseWritingDirection
                                         remainingRect:remainingRect];
  if (self.inclusionPathBitmap) {
    rect = CGRectIntersection(self.inclusionPathBoundingBox, rect);
    if (! CGRectIsEmpty(rect)) {
      rect = [self clipRectToInclusionPaths:rect remainingRect:remainingRect];
    }
  }
  rect = CGRectIntersection(rect, proposedRect);

//NSLog(@"p:%@, f:%@, r:%@",
//      NSStringFromCGRect(proposedRect),
//      NSStringFromCGRect(rect),
//      NSStringFromCGRect(*remainingRect));

  return rect;
}

@end
