//
//  CALayer+RNAnimation.m
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

#import "CALayer+RNAnimation.h"

@implementation CALayer (CALayer_RNAnimation)

- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay {
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  [self setValue:value forKeyPath:keyPath];
  CABasicAnimation *anim;
  anim = [CABasicAnimation animationWithKeyPath:keyPath];
  anim.duration = duration;
  anim.beginTime = CACurrentMediaTime() + delay;
  anim.fillMode = kCAFillModeBoth;
  anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
  anim.toValue = value;
  [self addAnimation:anim forKey:keyPath];
  [CATransaction commit];
}

@end
