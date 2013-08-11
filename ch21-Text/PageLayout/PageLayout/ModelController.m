//
//  ModelController.m
//  PageLayout
//
//  Created by Rob Napier on 8/10/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ModelController.h"

#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.

 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.

 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController() <NSLayoutManagerDelegate>
@property (nonatomic, readonly) NSLayoutManager *layoutManager;
@property (nonatomic, readonly) NSMutableArray *pageViewControllers;
@end

@implementation ModelController
@synthesize layoutManager = _layoutManager;
@synthesize pageViewControllers = _pageViewControllers;

- (id)init {
  self = [super init];
  if (self) {
    _layoutManager = [NSLayoutManager new];
    [_layoutManager setDelegate:self];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
    [textStorage addLayoutManager:_layoutManager];

    _pageViewControllers = [NSMutableArray new];
  }
  return self;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
  if ([self.pageViewControllers count] < index) {
    return self.pageViewControllers[index];
  }

  // Create a new view controller and pass suitable data.
  DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
  dataViewController.pageNumber = index + 1;
  self.pageViewControllers[index] = dataViewController;

  return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{
  return [self.pageViewControllers indexOfObject:viewController];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }

  index--;
  return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
  if (index == NSNotFound) {
    return nil;
  }

  index++;
//  if (index == [self.pageViewControllers count]) {
//    return nil;
//  }
  return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {

}


@end
