//
//  PTLScribbleLayoutManager.m
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PTLScribbleLayoutManager.h"
#import "PTLScribbleTextStorage.h"

@implementation PTLScribbleLayoutManager

- (void)drawGlyphsForGlyphRange:(NSRange)glyphsToShow
                        atPoint:(CGPoint)origin {

  // Determine the character range so you can check the attributes
  NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow
                                            actualGlyphRange:NULL];

  // Enumerate each time PTLRedactStyleAttributeName changes
  [self.textStorage enumerateAttribute:PTLRedactStyleAttributeName
                               inRange:characterRange
                               options:0
                            usingBlock:^(id value,
                                         NSRange attributeCharacterRange,
                                         BOOL *stop) {
                              [self redactCharacterRange:attributeCharacterRange
                                                  ifTrue:value
                                                 atPoint:origin];
                            }];
}

- (void)redactCharacterRange:(NSRange)characterRange
                      ifTrue:(NSNumber *)value
                     atPoint:(CGPoint)origin {

  // Switch back to glyph ranges, since we're drawing
  NSRange glyphRange = [self glyphRangeForCharacterRange:characterRange
                                    actualCharacterRange:NULL];
  if ([value boolValue]) {

    // Prepare the context. origin is in view coordinates.
    // The methods below will return text container coordinates,
    // so apply a translation
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, origin.x, origin.y);
    [[UIColor blackColor] setStroke];

    // Enumerate contiguous rectangles that enclose the redacted glyphs
    NSTextContainer *
    container = [self textContainerForGlyphAtIndex:glyphRange.location
                                    effectiveRange:NULL];

    [self enumerateEnclosingRectsForGlyphRange:glyphRange
                      withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                               inTextContainer:container
                                    usingBlock:^(CGRect rect, BOOL *stop){
                                      [self drawRedactionInRect:rect];
                                    }];
    CGContextRestoreGState(context);
  }
  else {
    // Wasn’t redacted. Use default behavior.
    [super drawGlyphsForGlyphRange:glyphRange atPoint:origin];
  }
}

- (void)drawRedactionInRect:(CGRect)rect {
  // Draw a box with an X through it.
  // You could draw anything here.
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
  CGFloat minX = CGRectGetMinX(rect);
  CGFloat minY = CGRectGetMinY(rect);
  CGFloat maxX = CGRectGetMaxX(rect);
  CGFloat maxY = CGRectGetMaxY(rect);
  [path moveToPoint:   CGPointMake(minX, minY)];
  [path addLineToPoint:CGPointMake(maxX, maxY)];
  [path moveToPoint:   CGPointMake(maxX, minY)];
  [path addLineToPoint:CGPointMake(minX, maxY)];
  [path stroke];
}

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow
                            atPoint:(CGPoint)origin {
  [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];

  CGContextRef context = UIGraphicsGetCurrentContext();
  NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow
                                            actualGlyphRange:NULL];
  [self.textStorage enumerateAttribute:PTLHighlightColorAttributeName
                               inRange:characterRange
                               options:0
                            usingBlock:^(id value,
                                         NSRange highlightedCharacterRange,
                                         BOOL *stop) {
                              [self highlightCharacterRange:highlightedCharacterRange
                                                      color:value
                                                    atPoint:origin
                                                  inContext:context];
                            }];
}

- (void)highlightCharacterRange:(NSRange)highlightedCharacterRange
                          color:(UIColor *)color
                        atPoint:(CGPoint)origin
                      inContext:(CGContextRef)context {
  if (color) {
    CGContextSaveGState(context);
    [color setFill];
    CGContextTranslateCTM(context, origin.x, origin.y);

    NSRange
    highlightedGlyphRange = [self glyphRangeForCharacterRange:highlightedCharacterRange
                                         actualCharacterRange:NULL];
    NSTextContainer *
    container = [self textContainerForGlyphAtIndex:highlightedGlyphRange.location
                                    effectiveRange:NULL];

    [self enumerateEnclosingRectsForGlyphRange:highlightedGlyphRange
                      withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                               inTextContainer:container
                                    usingBlock:^(CGRect rect, BOOL *stop){
                                      [self drawHighlightInRect:rect];
                                    }];
    CGContextRestoreGState(context);
  }
}

- (void)drawHighlightInRect:(CGRect)rect {
  CGRect highlightRect = CGRectInset(rect, -3, -3);
  UIRectFill(highlightRect);
  [[UIBezierPath bezierPathWithOvalInRect:highlightRect] stroke];
}

@end
