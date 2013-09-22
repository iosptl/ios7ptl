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

#if REVISION == 5

#import "RNTimer.h"

static const CGFloat kFontSize = 16.0;

@interface ZipTextView ()
@property (nonatomic) NSUInteger index;
@property (nonatomic) RNTimer *timer;
@property (nonatomic) NSString *text;
@property (nonatomic) NSMutableArray *locations;
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
    _locations = [NSMutableArray
                  arrayWithObject:[NSValue
                                   valueWithCGPoint:CGPointZero]];
  }
  return self;
}

- (void)appendNextCharacter {
  self.index++;
  if (self.index < self.text.length) {
    CGRect dirtyRect;
    dirtyRect.origin = [self originAtIndex:self.index fontSize:kFontSize];
    dirtyRect.size = CGSizeMake(kFontSize, kFontSize);
    [self setNeedsDisplayInRect:dirtyRect];
  }
}

- (void)drawRect:(CGRect)rect {
  for (NSUInteger i = 0; i <= self.index; i++) {
    if (i < self.text.length) {
      NSString *character = [self.text substringWithRange:
                             NSMakeRange(i, 1)];
      CGPoint origin = [self originAtIndex:i fontSize:kFontSize];
      if (CGRectContainsPoint(rect, origin)) {
        [character drawAtPoint:origin
                withAttributes:@{ NSFontAttributeName:
                                    [UIFont systemFontOfSize:kFontSize]}];
      }
    }
  }
}

- (CGPoint)originAtIndex:(NSUInteger)index
                fontSize:(CGFloat)fontSize {
  if ([self.locations count] > index) {
    return [self.locations[index] CGPointValue];
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
    self.locations[index] = [NSValue valueWithCGPoint:origin];
    return origin;
  }
}

@end
#endif