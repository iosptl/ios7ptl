//
//  ColumnView.m
//  Columns
//
//  Created by Rob Napier on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ColumnView.h"
#import <CoreText/CoreText.h>

static const CFIndex kColumnCount = 3;

@interface ColumnView ()
@property (nonatomic, readwrite, assign) CFIndex mode;
@end

@implementation ColumnView

- (CGRect *)copyColumnRects {
  CGRect bounds = CGRectInset([self bounds], 20.0, 20.0);
  
  int column;
  CGRect* columnRects = (CGRect*)calloc(kColumnCount,
                                        sizeof(*columnRects));
  
  // Start by setting the first column to cover the entire view.
  columnRects[0] = bounds;
  // Divide the columns equally across the frame's width.
  CGFloat columnWidth = CGRectGetWidth(bounds) / kColumnCount;
  for (column = 0; column < kColumnCount - 1; column++) {
    CGRectDivide(columnRects[column], &columnRects[column],
                 &columnRects[column + 1], columnWidth, 
                 CGRectMinXEdge);
  }
  
  // Inset all columns by a few pixels of margin.
  for (column = 0; column < kColumnCount; column++) {
    columnRects[column] = CGRectInset(columnRects[column], 
                                      10.0, 10.0);
  }
  return columnRects;
}

- (CFArrayRef)copyPaths
{   
  CFMutableArrayRef 
  paths = CFArrayCreateMutable(kCFAllocatorDefault,
                               kColumnCount,
                               &kCFTypeArrayCallBacks);
  
  switch (self.mode) {
    case 0: // 3 columns
    {
      CGRect *columnRects = [self copyColumnRects];
      // Create an array of layout paths, one for each column.
      for (int column = 0; column < kColumnCount; column++) {
        CGPathRef 
        path = CGPathCreateWithRect(columnRects[column], NULL);
        CFArrayAppendValue(paths, path);
        CGPathRelease(path);
      }
      free(columnRects);
      break;
    }
      
    case 1: // 3 columns as a single path
    {
      CGRect *columnRects = [self copyColumnRects];
      
      // Create a single path that contains all columns
      CGMutablePathRef path = CGPathCreateMutable();
      for (int column = 0; column < kColumnCount; column++) {
        CGPathAddRect(path, NULL, columnRects[column]);
      }
      free(columnRects);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);
      break;    
    }
      
    case 2: // two columns with box
    {
      CGMutablePathRef path = CGPathCreateMutable();
      CGPathMoveToPoint(path, NULL, 30, 30);  // Bottom left
      CGPathAddLineToPoint(path, NULL, 344, 30);  // Bottom right
      
      CGPathAddLineToPoint(path, NULL, 344, 400);
      CGPathAddLineToPoint(path, NULL, 200, 400);
      CGPathAddLineToPoint(path, NULL, 200, 800);
      CGPathAddLineToPoint(path, NULL, 344, 800);
      
      CGPathAddLineToPoint(path, NULL, 344, 944); // Top right
      CGPathAddLineToPoint(path, NULL, 30, 944);  // Top left
      CGPathCloseSubpath(path);
      CFArrayAppendValue(paths, path);
      CFRelease(path);
      
      path = CGPathCreateMutable();
      CGPathMoveToPoint(path, NULL, 700, 30); // Bottom right
      CGPathAddLineToPoint(path, NULL, 360, 30);  // Bottom left
      
      CGPathAddLineToPoint(path, NULL, 360, 400);
      CGPathAddLineToPoint(path, NULL, 500, 400);
      CGPathAddLineToPoint(path, NULL, 500, 800);
      CGPathAddLineToPoint(path, NULL, 360, 800);
      
      CGPathAddLineToPoint(path, NULL, 360, 944); // Top left
      CGPathAddLineToPoint(path, NULL, 700, 944); // Top right
      CGPathCloseSubpath(path);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);    
      break;
    }
    case 3: // ellipse
    {       
      CGPathRef 
      path = CGPathCreateWithEllipseInRect(CGRectInset([self bounds],
                                                       30, 
                                                       30),
                                           NULL);
      CFArrayAppendValue(paths, path);
      CGPathRelease(path);
      break;
    }           
  }
  return paths;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Flip the view's context. Core Text runs bottom to top, even 
    // on iPad, and the view is much simpler if we do everything in
    // Mac coordinates.
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
    self.transform = transform;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  if (self.attributedString == nil)
  {
    return;
  }
  
  // Initialize the context (always initialize your text matrix)
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  
  CFAttributedStringRef 
  attrString = (__bridge CFTypeRef)self.attributedString;
  
  CTFramesetterRef
  framesetter = CTFramesetterCreateWithAttributedString(attrString);
  
  CFArrayRef paths = [self copyPaths];
  CFIndex pathCount = CFArrayGetCount(paths);
  CFIndex charIndex = 0;
  for (CFIndex pathIndex = 0; pathIndex < pathCount; ++pathIndex) {
    CGPathRef path = CFArrayGetValueAtIndex(paths, pathIndex);
    
    CTFrameRef
    frame = CTFramesetterCreateFrame(framesetter, 
                                     CFRangeMake(charIndex, 0),
                                     path,
                                     NULL); 
    CTFrameDraw(frame, context);
    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    charIndex += frameRange.length;      
    CFRelease(frame);
  }
  
  CFRelease(paths);
  CFRelease(framesetter);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  self.mode = (self.mode + 1 ) % 4;
  [self setNeedsDisplay];
}

@end
