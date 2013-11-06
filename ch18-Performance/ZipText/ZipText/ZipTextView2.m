//
//  ZipTextView.m
//  ZipText
//
//  Copyright (c) 2012 Rob Napier
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

#import "ZipTextView.h"

#if REVISION == 2

#import "RNTimer.h"

static const CGFloat kFontSize = 16.0;

@interface ZipTextView ()
@property (nonatomic) NSUInteger index;
@property (nonatomic) RNTimer *timer;
@property (nonatomic) NSString *text;
@end

@implementation ZipTextView

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
  self = [super initWithFrame:frame];
  if (self) {
    __weak ZipTextView *weakSelf = self;
    _timer = [RNTimer
              repeatingTimerWithTimeInterval:0.01
              block:^{
                [weakSelf appendNextCharacter];
              }];
    _text = [text copy];
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)appendNextCharacter {
  NSUInteger i = self.index;
  if (i < self.text.length) {
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.text substringWithRange:NSMakeRange(i,1)];
    label.opaque = NO;
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin = [self originAtIndex:i
                              fontSize:label.font.pointSize];
    label.frame = frame;
    [self addSubview:label];
  }
  self.index++;
}

- (CGPoint)originAtIndex:(NSUInteger)index
                fontSize:(CGFloat)fontSize {
  if (index == 0) {
    return CGPointZero;
  }
  else {
    CGPoint origin = [self originAtIndex:index-1 fontSize:fontSize];
    NSString *
    prevCharacter = [self.text
                     substringWithRange:NSMakeRange(index-1,1)];
    CGSize
    prevCharacterSize = [prevCharacter
                         sizeWithAttributes:@{ NSFontAttributeName:
                                                 [UIFont systemFontOfSize:fontSize]
                                               }];
    origin.x += prevCharacterSize.width;
    if (origin.x > CGRectGetWidth(self.bounds)) {
      origin.x = 0;
      origin.y += prevCharacterSize.height;
    }
    return origin;
  }
}

@end
#endif