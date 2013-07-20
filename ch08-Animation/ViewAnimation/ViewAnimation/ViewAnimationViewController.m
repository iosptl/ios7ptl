//
//  ViewAnimationViewController.m
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

#import "ViewAnimationViewController.h"
#import "CircleView.h"

@implementation ViewAnimationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.circleView = [[CircleView alloc] initWithFrame:
                     CGRectMake(0, 0, 20, 20)];
  self.circleView.center = CGPointMake(100, 40);
  [[self view] addSubview:self.circleView];
  
  UITapGestureRecognizer *g;
  g = [[UITapGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(dropAnimate:)];
  [[self view] addGestureRecognizer:g];
}

- (void)dropAnimate:(UIGestureRecognizer *)recognizer {
  [UIView
   animateWithDuration:3 animations:^{
     recognizer.enabled = NO;
     self.circleView.center = CGPointMake(100, 300);
   }
   completion:^(BOOL finished){
     [UIView 
      animateWithDuration:1 animations:^{
        self.circleView.center = CGPointMake(250, 300);
      }
      completion:^(BOOL finished){
        recognizer.enabled = YES;
      }
      ];
   }];
}

@end
