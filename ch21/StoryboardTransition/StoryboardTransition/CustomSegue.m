//
//  CustomSegue.m
//  StoryboardTransition
//
//  Created by Mugunth Kumar on 24/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void) perform {
  
  UIViewController *src = (UIViewController *)self.sourceViewController;
  UIViewController *dest = (UIViewController *)self.destinationViewController;
  
  CGRect f = src.view.frame;
  CGRect originalSourceRect = src.view.frame;
  f.origin.y = f.size.height;

  [UIView animateWithDuration:0.3 animations:^{
    src.view.frame = f;
    
  } completion:^(BOOL finished){
    src.view.alpha = 0;
    dest.view.frame = f;
    dest.view.alpha = 0.0f;
    [[src.view superview] addSubview:dest.view];
    [UIView animateWithDuration:0.3 animations:^{
      
      dest.view.frame = originalSourceRect;
      dest.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
      
      [dest.view removeFromSuperview];
      src.view.alpha = 1.0f;
      [src.navigationController pushViewController:dest animated:NO];
    }];    
  }];
}
@end
