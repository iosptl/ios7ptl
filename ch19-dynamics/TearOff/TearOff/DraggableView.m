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
@property (nonatomic) UIGestureRecognizer *gestureRecognizer;
@end

@implementation DraggableView

- (instancetype)initWithFrame:(CGRect)frame
                     animator:(UIDynamicAnimator *)animator {
  self = [super initWithFrame:frame];
  if (self) {
    _dynamicAnimator = animator;
    self.backgroundColor = [UIColor darkGrayColor];
    self.layer.borderWidth = 2;
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(handlePan:)];
    [self addGestureRecognizer:self.gestureRecognizer];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  DraggableView *newView = [[[self class] alloc]
                            initWithFrame:CGRectZero
                            animator:self.dynamicAnimator];
  newView.bounds = self.bounds;
  newView.center = self.center;
  newView.transform = self.transform;
  newView.alpha = self.alpha;
  return newView;
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
  if (g.state == UIGestureRecognizerStateEnded ||
      g.state == UIGestureRecognizerStateCancelled) {
    [self stopDragging];
  }
  else {
    [self dragToPoint:[g locationInView:self.superview]];
  }
}

- (void)dragToPoint:(CGPoint)point {
  [self.dynamicAnimator removeBehavior:self.snapBehavior];
  self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self
                                               snapToPoint:point];
  self.snapBehavior.damping = .25;
  [self.dynamicAnimator addBehavior:self.snapBehavior];
}

- (void)stopDragging {
  [self.dynamicAnimator removeBehavior:self.snapBehavior];
  self.snapBehavior = nil;
}

@end
