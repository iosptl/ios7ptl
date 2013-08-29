//
//  SCTPercentDrivenAnimator.m
//  InteractiveCustomTransitionsDemo
//
//  Created by Mugunth on 28/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTPercentDrivenAnimator.h"

@interface SCTPercentDrivenAnimator (/*Private Methods*/)
@property (nonatomic, assign) float startScale;
@property (weak, nonatomic) UIViewController *controller;
@end

@implementation SCTPercentDrivenAnimator

-(instancetype) initWithViewController:(UIViewController*) controller {
  
  if((self = [super init])) {
    
    self.controller = controller;
  }
  
  return self;
}

-(void) pinchGestureAction:(UIPinchGestureRecognizer*) gestureRecognizer {
  
  CGFloat scale = gestureRecognizer.scale;
  if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
    self.startScale = scale;
    [self.controller dismissViewControllerAnimated:YES completion:nil];
  }
  if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    
    CGFloat completePercent = 1.0 - (scale/self.startScale);
    [self updateInteractiveTransition:completePercent];
  }
  if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
    if(gestureRecognizer.velocity >= 0)
       [self cancelInteractiveTransition];
    else
      [self finishInteractiveTransition];
  }
  
  if(gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
    
    [self cancelInteractiveTransition];
  }
}
@end
