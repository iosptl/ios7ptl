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
//                                NSLog(@"Filling:%@", NSStringFromRange(range));
                                UIColor *color = value;
                                [color setFill];
                                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), origin.x, origin.y);

                                NSRange highlightedGlyphRange = [self glyphRangeForCharacterRange:highlightedCharacterRange actualCharacterRange:NULL];
                                NSTextContainer *container = [self textContainerForGlyphAtIndex:highlightedGlyphRange.location effectiveRange:NULL];

                                [self enumerateEnclosingRectsForGlyphRange:highlightedGlyphRange
                                                  withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                                                           inTextContainer:container usingBlock:^(CGRect highlightRect, BOOL *stop){
                                                             [self fillBackgroundRectArray:&highlightRect
                                                                                     count:1
                                                                         forCharacterRange:characterRange // Informational
                                                                                     color:color]; // Informational
                                                           }];
                                CGContextRestoreGState(UIGraphicsGetCurrentContext());
                              }
                            }];
}


- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color {
  [super fillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:color];

}


@end
