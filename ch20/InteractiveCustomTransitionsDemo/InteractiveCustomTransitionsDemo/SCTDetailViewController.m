//
//  SCTDetailViewController.m
//  CustomTransitionsDemo
//
//  Created by Mugunth on 20/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTDetailViewController.h"

#import "SCTPercentDrivenAnimator.h"
@interface SCTDetailViewController ()
- (void)configureView;
@property (strong, nonatomic) SCTPercentDrivenAnimator *animator;
@end

@implementation SCTDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

-(IBAction)closeButtonTapped:(id)sender {

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  return 1.0f;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  [self startInteractiveTransition:transitionContext];
}

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *src = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  
  CGPoint centerPoint = src.view.center;
  [UIView animateWithDuration:1.0 animations:^{
    
    src.view.frame = CGRectMake(centerPoint.x, centerPoint.y, 10, 10);
    src.view.center = centerPoint;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem) {
      self.detailDescriptionLabel.text = [self.detailItem description];
  }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  
  return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
  
  return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
  
  return self.animator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
  self.animator = [[SCTPercentDrivenAnimator alloc] initWithViewController:self];
  UIPinchGestureRecognizer *gr = [[UIPinchGestureRecognizer alloc] initWithTarget:self.animator
                                                                           action:@selector(pinchGestureAction:)];
  
  [self.view addGestureRecognizer:gr];

  self.transitioningDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
