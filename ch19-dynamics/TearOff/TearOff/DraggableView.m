//
//  DraggableView.m
//  TearOff
//
//  Created by Rob Napier on 9/14/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()
@property (nonatomic) UISnapBehavior *snapBehavior;
@property (nonatomic) UIDynamicAnimator *dynamicAnimator;
@end

@implementation DraggableView

- (instancetype)initWithFrame:(CGRect)frame
                     animator:(UIDynamicAnimator *)animator {
  self = [super initWithFrame:frame];
  if (self) {
    _dynamicAnimator = animator;
    self.backgroundColor = [UIColor darkGrayColor];
    self.layer.borderWidth = 2;
    UIPanGestureRecognizer *
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
  }
  return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
  [self dragToPoint:[g locationInView:self.superview]];
}

- (void)dragToPoint:(CGPoint)point {
  [self.dynamicAnimator removeBehavior:self.snapBehavior];
  self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self
                                               snapToPoint:point];
  self.snapBehavior.damping = .25;
  [self.dynamicAnimator addBehavior:self.snapBehavior];
}

@end
