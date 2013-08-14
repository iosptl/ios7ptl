//
//  LayoutView.m
//  DuplicateLayout
//
//  Created by Rob Napier on 8/12/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "LayoutView.h"

@interface LayoutView () <NSLayoutManagerDelegate>
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer;
@end

@implementation LayoutView

- (void)awakeFromNib {
  // Create a text container half as wide as our bounds
  CGSize size = self.bounds.size;
  size.width /= 2;
  self.textContainer = [[NSTextContainer alloc] initWithSize:size];
  self.layoutManager = [NSLayoutManager new];
  self.layoutManager.delegate = self;
  [self.layoutManager addTextContainer:self.textContainer];

  [self.textView.textStorage addLayoutManager:self.layoutManager];
}

- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  NSLayoutManager *lm = self.layoutManager;
  NSRange range = [lm glyphRangeForTextContainer:self.textContainer];
  CGPoint point = CGPointZero;
  [lm drawBackgroundForGlyphRange:range atPoint:point];
  [lm drawGlyphsForGlyphRange:range atPoint:point];
}

@end
