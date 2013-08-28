//
//  LayoutView.m
//  CircleLayout
//
//  Created by Rob Napier on 8/28/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "LayoutView.h"

@interface LayoutView ()
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer;
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, strong) NSTextStorage *textStorage;
@end

@implementation LayoutView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
  self = [super initWithFrame:frame];
  if (self) {
    _textContainer = textContainer;
    _layoutManager = textContainer.layoutManager;
    _textStorage = _layoutManager.textStorage;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  NSLayoutManager *layoutManger = self.textContainer.layoutManager;
  NSRange glyphRange = [layoutManger glyphRangeForTextContainer:self.textContainer];
  CGPoint point = self.bounds.origin;
  [layoutManger drawBackgroundForGlyphRange:glyphRange atPoint:point];
  [layoutManger drawGlyphsForGlyphRange:glyphRange atPoint:point];
}

@end
