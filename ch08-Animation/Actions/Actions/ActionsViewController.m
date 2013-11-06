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
#import "ActionsViewController.h"
#import "CircleLayer.h"

@implementation ActionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CircleLayer *circleLayer = [CircleLayer new];
  circleLayer.radius = 20;
  circleLayer.frame = self.view.bounds;
  [self.view.layer addSublayer:circleLayer];
  
  CABasicAnimation *anim = [CABasicAnimation
                            animationWithKeyPath:@"position"];
  anim.duration = 2;
  NSMutableDictionary *actions = [NSMutableDictionary
                                  dictionaryWithDictionary:
                                  [circleLayer actions]];
  actions[@"position"] = anim;
  
  CABasicAnimation *fadeAnim = [CABasicAnimation 
                                animationWithKeyPath:@"opacity"];
  fadeAnim.fromValue = @0.4;
  fadeAnim.toValue = @1.0;

  CABasicAnimation *growAnim = [CABasicAnimation
                                animationWithKeyPath:
                                @"transform.scale"];
  growAnim.fromValue = @0.8;
  growAnim.toValue = @1.0;
  
  CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
  groupAnim.animations = @[fadeAnim, growAnim];
  
  actions[kCAOnOrderIn] = groupAnim;
  
  circleLayer.actions = actions;

  UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(tap:)];
  [self.view addGestureRecognizer:g];
}

- (void)tap:(UIGestureRecognizer *)recognizer {
  CircleLayer *circleLayer = 
      (CircleLayer*)(self.view.layer.sublayers)[0];
  circleLayer.position = CGPointMake(100, 100);
  [CATransaction setAnimationDuration:2];
  circleLayer.radius = 100.0;
}

@end
