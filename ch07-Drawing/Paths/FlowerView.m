//
//  FlowerView.m
//  Paths
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

#import "FlowerView.h"

@implementation FlowerView

- (void)awakeFromNib {
  // Comment this line to see default behavior
  self.contentMode = UIViewContentModeRedraw;
}

- (void)drawRect:(CGRect)rect {
  CGSize size = self.bounds.size;
  CGFloat margin = 10;
  CGFloat radius = rintf(MIN(size.height - margin,
                              size.width - margin) / 4);
  
  CGFloat xOffset, yOffset;
  CGFloat offset = rintf((size.height - size.width) / 2);
  if (offset > 0) {
    xOffset = (CGFloat)rint(margin / 2);
    yOffset = offset;
  } else {
    xOffset = -offset;
    yOffset = rintf(margin / 2);
  }
  
  [[UIColor redColor] setFill];
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path addArcWithCenter:CGPointMake(radius * 2 + xOffset,
                                     radius + yOffset)
                  radius:radius
              startAngle:(CGFloat)-M_PI
                endAngle:0
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(radius * 3 + xOffset,
                                     radius * 2 + yOffset)
                  radius:radius
              startAngle:(CGFloat)-M_PI_2
                endAngle:(CGFloat)M_PI_2
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(radius * 2 + xOffset,
                                     radius * 3 + yOffset)
                  radius:radius
              startAngle:0
                endAngle:(CGFloat)M_PI
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(radius + xOffset,
                                     radius * 2 + yOffset)
                  radius:radius
              startAngle:(CGFloat)M_PI_2
                endAngle:(CGFloat)-M_PI_2
               clockwise:YES];
  [path closePath];
  [path fill];
}

@end
