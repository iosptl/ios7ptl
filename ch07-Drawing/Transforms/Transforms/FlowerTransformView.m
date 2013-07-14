//
//  FlowerTransformView.m
//  Transforms
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

#import "FlowerTransformView.h"

@implementation FlowerTransformView

- (void)awakeFromNib {
  self.contentMode = UIViewContentModeRedraw;
}

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy)
{
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

- (void)drawRect:(CGRect)rect { 
  CGSize size = self.bounds.size;
  CGFloat margin = 10;

  [[UIColor redColor] set];
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path addArcWithCenter:CGPointMake(0, -1)
                  radius:1
              startAngle:(CGFloat)-M_PI
                endAngle:0
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(1, 0)
                  radius:1
              startAngle:(CGFloat)-M_PI_2
                endAngle:(CGFloat)M_PI_2
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(0, 1)
                  radius:1
              startAngle:0
                endAngle:(CGFloat)M_PI
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(-1, 0)
                  radius:1
              startAngle:(CGFloat)M_PI_2
                endAngle:(CGFloat)-M_PI_2
               clockwise:YES];
  
  CGFloat scale = floorf((MIN(size.height, size.width)
                         - margin) / 4);
  
  CGAffineTransform transform;
  transform = CGAffineTransformMakeScaleTranslate(scale, 
                                                  scale,
                                              size.width/2,
                                            size.height/2);
  [path applyTransform:transform];
  [path fill];
}

@end
