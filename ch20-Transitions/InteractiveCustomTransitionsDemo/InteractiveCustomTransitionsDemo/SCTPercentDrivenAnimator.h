//
//  SCTPercentDrivenAnimator.h
//  InteractiveCustomTransitionsDemo
//
//  Created by Mugunth on 28/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTPercentDrivenAnimator : UIPercentDrivenInteractiveTransition
-(instancetype) initWithViewController:(UIViewController*) controller;
-(void) pinchGestureAction:(UIPinchGestureRecognizer*) gestureRecognizer;
@end
