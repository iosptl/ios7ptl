//
//  RootViewController.m
//  PageLayout
//
//  Created by Rob Napier on 8/10/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  // Configure the page view controller and add it as a child view controller.
  self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  self.pageViewController.delegate = self;

  DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
  NSArray *viewControllers = @[startingViewController];
  [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

  self.pageViewController.dataSource = self.modelController;

  [self addChildViewController:self.pageViewController];
  [self.view addSubview:self.pageViewController.view];

  // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
  CGRect pageViewRect = self.view.bounds;
  pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
  self.pageViewController.view.frame = pageViewRect;

  [self.pageViewController didMoveToParentViewController:self];

  // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
  self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
  // Return the model controller object, creating it if necessary.
  // In more complex implementations, the model controller may be passed to the view controller.
  if (!_modelController) {
    _modelController = [[ModelController alloc] init];
  }
  return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {

 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  if (UIInterfaceOrientationIsPortrait(orientation)) {
    // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
  }

  // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
  DataViewController *currentViewController = self.pageViewController.viewControllers[0];
  NSArray *viewControllers = nil;

  NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
  if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
    UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
    viewControllers = @[currentViewController, nextViewController];
  } else {
    UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
    viewControllers = @[previousViewController, currentViewController];
  }
  [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


  return UIPageViewControllerSpineLocationMid;
}

@end
