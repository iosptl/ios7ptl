//  Copyright (c) 2013 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
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
