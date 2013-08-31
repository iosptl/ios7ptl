//
//  ScribbleLayoutManager.m
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ScribbleLayoutManager.h"
#import "ScribbleTextStorage.h"

@implementation ScribbleLayoutManager

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
  [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];

  NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow actualGlyphRange:NULL];
  [self.textStorage enumerateAttribute:HighlightColorAttributeName
                               inRange:characterRange
                               options:0
                            usingBlock:^(id value, NSRange highlightedCharacterRange, BOOL *stop) {
                              if (value) {
                                CGContextSaveGState(UIGraphicsGetCurrentContext());
                                UIColor *color = value;
                                [color setFill];
                                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), origin.x, origin.y);

                                NSRange highlightedGlyphRange = [self glyphRangeForCharacterRange:highlightedCharacterRange actualCharacterRange:NULL];
                                NSTextContainer *container = [self textContainerForGlyphAtIndex:highlightedGlyphRange.location effectiveRange:NULL];

                                [self enumerateEnclosingRectsForGlyphRange:highlightedGlyphRange
                                                  withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                                                           inTextContainer:container usingBlock:^(CGRect rect, BOOL *stop){
                                                             CGRect highlightRect = CGRectInset(rect, -3, -3);
                                                             UIRectFill(highlightRect);
                                                             [[UIBezierPath bezierPathWithOvalInRect:highlightRect] stroke];
                                                           }];
                                CGContextRestoreGState(UIGraphicsGetCurrentContext());
                              }
                            }];
}

- (void)drawGlyphsForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
  NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow actualGlyphRange:NULL];
  [self.textStorage enumerateAttribute:RedactStyleAttributeName
                               inRange:characterRange
                               options:0
                            usingBlock:^(id value, NSRange attributeCharacterRange, BOOL *stop) {
                              NSRange glyphRange = [self glyphRangeForCharacterRange:attributeCharacterRange actualCharacterRange:NULL];
                              if (value) {
                                CGContextSaveGState(UIGraphicsGetCurrentContext());
                                UIColor *color = [UIColor colorWithWhite:.75 alpha:.5];
                                [color setFill];
                                [[UIColor blackColor] setStroke];

                                NSTextContainer *container = [self textContainerForGlyphAtIndex:glyphRange.location effectiveRange:NULL];
                                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), origin.x, origin.y);
                                [self enumerateEnclosingRectsForGlyphRange:glyphRange
                                                  withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                                                           inTextContainer:container usingBlock:^(CGRect rect, BOOL *stop){
                                                             UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
                                                             [path moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
                                                             [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
                                                             [path moveToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
                                                             [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
                                                             [path stroke];
                                                           }];
                                CGContextRestoreGState(UIGraphicsGetCurrentContext());
                              }
                              else {
                                [super drawGlyphsForGlyphRange:glyphRange atPoint:origin];
                              }
                            }];
  
  
}

@end
