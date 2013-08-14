//
//  CircleView.m
//  CircleLayout
//
//  Created by Rob Napier on 8/14/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()
@property (nonatomic, readwrite, strong) NSTextStorage *textStorage;
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer;
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@end

@implementation CircleView

- (void)awakeFromNib {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  style.alignment = NSTextAlignmentJustified;

  self.textStorage = [[NSTextStorage alloc] initWithString:string
                                                attributes:@{
                                                             NSParagraphStyleAttributeName: style
                                                             }];

  self.layoutManager = [NSLayoutManager new];
  [self.textStorage addLayoutManager:self.layoutManager];

  self.textContainer = [NSTextContainer new];
  [self.layoutManager addTextContainer:self.textContainer];
}

- (void)drawRect:(CGRect)rect {
  CGRect textRect = CGRectInset(self.bounds, 1, 10);
  self.textContainer.size = textRect.size;

  UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:textRect];
  [exclusionPath appendPath:[UIBezierPath bezierPathWithOvalInRect:textRect]];
  exclusionPath.usesEvenOddFillRule = YES;
  self.textContainer.exclusionPaths = @[ exclusionPath ];

  NSLayoutManager *lm = self.layoutManager;
  NSRange range = [lm glyphRangeForTextContainer:self.textContainer];
  [lm drawBackgroundForGlyphRange:range atPoint:textRect.origin];
  [lm drawGlyphsForGlyphRange:range atPoint:textRect.origin];
}

@end
