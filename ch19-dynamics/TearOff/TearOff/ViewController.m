//
//  ViewController.m
//  TearOff
//
//  Created by Rob Napier on 9/14/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"

const CGFloat kShapeDimension = 100.0;

@interface ViewController ()
@property (nonatomic) UIDynamicAnimator *animator;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

  CGRect frame = CGRectMake(0, 0,
                            kShapeDimension,
                            kShapeDimension);
  DraggableView *dragView = [[DraggableView alloc] initWithFrame:frame
                                                        animator:self.animator];
  dragView.center = CGPointMake(self.view.center.x / 4,
                                self.view.center.y / 4);
  [self.view addSubview:dragView];
}

@end
