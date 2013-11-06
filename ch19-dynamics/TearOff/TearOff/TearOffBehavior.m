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
#import "TearOffBehavior.h"
#import "DraggableView.h"

@implementation TearOffBehavior

- (instancetype)initWithDraggableView:(DraggableView *)view
                               anchor:(CGPoint)anchor
                              handler:(TearOffHandler)handler {
  self = [super init];
  if (self) {
    _active = YES;

    [self addChildBehavior:[[UISnapBehavior alloc] initWithItem:view
                                                    snapToPoint:anchor]];

    CGFloat distance = MIN(CGRectGetWidth(view.bounds),
                           CGRectGetHeight(view.bounds));

    TearOffBehavior * __weak weakself = self;
    self.action = ^{
      TearOffBehavior *strongself = weakself;
      if (! PointsAreWithinDistance(view.center, anchor, distance)) {
        if (strongself.active) {
          DraggableView *newView = [view copy];
          [view.superview addSubview:newView];
          TearOffBehavior *newTearOff = [[[strongself class] alloc]
                                         initWithDraggableView:newView
                                         anchor:anchor
                                         handler:handler];
          newTearOff.active = NO;
          [strongself.dynamicAnimator addBehavior:newTearOff];
          handler(view, newView);
          [strongself.dynamicAnimator removeBehavior:strongself];
        }
      }
      else {
        strongself.active = YES;
      }
    };
  }
  return self;
}

BOOL PointsAreWithinDistance(CGPoint p1,
                             CGPoint p2,
                             CGFloat distance) {
  CGFloat dx = p1.x - p2.x;
  CGFloat dy = p1.y - p2.y;
  CGFloat currentDistance = hypotf(dx, dy);
  return (currentDistance < distance);
}

@end
