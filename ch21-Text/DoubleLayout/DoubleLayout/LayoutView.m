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
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer1;
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer2;
@end

@implementation LayoutView

- (void)awakeFromNib {
  // Create two text containers
  CGSize size = CGSizeMake(CGRectGetWidth(self.bounds),
                           CGRectGetMidY(self.bounds) * .75);
  self.textContainer1 = [[NSTextContainer alloc] initWithSize:size];
  self.textContainer2 = [[NSTextContainer alloc] initWithSize:size];
  self.layoutManager = [NSLayoutManager new];
  self.layoutManager.delegate = self;
  [self.layoutManager addTextContainer:self.textContainer1];
  [self.layoutManager addTextContainer:self.textContainer2];

  [self.textView.textStorage addLayoutManager:self.layoutManager];
}

- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [self drawTextForTextContainer:self.textContainer1
                         atPoint:CGPointZero];

  CGPoint box2Corner = CGPointMake(CGRectGetMinX(self.bounds),
                                   CGRectGetMidY(self.bounds));
  [self drawTextForTextContainer:self.textContainer2
                         atPoint:box2Corner];
}

- (void)drawTextForTextContainer:(NSTextContainer *)textContainer
                         atPoint:(CGPoint)point {

  // Draw a line around the container
  CGRect box = {
    .origin = point,
    .size = textContainer.size
  };
  UIRectFrame(box);

  NSLayoutManager *lm = self.layoutManager;
  NSRange range = [lm glyphRangeForTextContainer:textContainer];
  [lm drawBackgroundForGlyphRange:range atPoint:point];
  [lm drawGlyphsForGlyphRange:range atPoint:point];
}

@end
