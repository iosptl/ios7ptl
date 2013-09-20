//
//  TearOffBehavior.m
//  TearOff
//
//  Created by Rob Napier on 9/18/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
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
