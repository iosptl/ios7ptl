//  Copyright (c) 2013 Rob Napier
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
#import "ViewController.h"
#import "DraggableView.h"
#import "TearOffBehavior.h"
#import "DefaultBehavior.h"

const CGFloat kShapeDimension = 100.0;
const NSUInteger kSliceCount = 6;

@interface ViewController ()
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) DefaultBehavior *defaultBehavior;
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
  dragView.alpha = 0.5;
  [self.view addSubview:dragView];

  DefaultBehavior *defaultBehavior = [DefaultBehavior new];
  [self.animator addBehavior:defaultBehavior];
  self.defaultBehavior = defaultBehavior;

  TearOffBehavior *tearOffBehavior = [[TearOffBehavior alloc]
                                      initWithDraggableView:dragView
                                      anchor:dragView.center
                                      handler:^(DraggableView *tornView,
                                                DraggableView *newPinView) {
                                        tornView.alpha = 1;
                                        [defaultBehavior addItem:tornView];

                                        // Double-tap to trash
                                        UITapGestureRecognizer *
                                        tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(trash:)];
                                        tap.numberOfTapsRequired = 2;
                                        [tornView addGestureRecognizer:tap];
                                      }];
  [self.animator addBehavior:tearOffBehavior];
}

- (void)trash:(UIGestureRecognizer *)g {
  UIView *view = g.view;

  // Calculate the new views.
  NSArray *subviews = [self sliceView:view
                             intoRows:kSliceCount
                              columns:kSliceCount];

  // Create a new animator
  UIDynamicAnimator *
  trashAnimator = [[UIDynamicAnimator alloc]
                   initWithReferenceView:self.view];

  // Create a new default behavior
  DefaultBehavior *defaultBehavior = [DefaultBehavior new];

  for (UIView *subview in subviews) {
    // Add the new "exploded" view to the hierarchy
    [self.view addSubview:subview];
    [defaultBehavior addItem:subview];

    // Create a push animation for each
    UIPushBehavior *
    push = [[UIPushBehavior alloc]
            initWithItems:@[subview]
            mode:UIPushBehaviorModeInstantaneous];
    [push setPushDirection:CGVectorMake((float)rand()/RAND_MAX - .5,
                                        (float)rand()/RAND_MAX - .5)];
    [trashAnimator addBehavior:push];

    // Fade out the pieces as they fly around.
    // At the end, remove them. Referencing trashAnimator here
    // also allows ARC to keep it around without an ivar.
    [UIView animateWithDuration:1
                     animations:^{
                       subview.alpha = 0;
                     }
                     completion:^(BOOL didComplete){
                       [subview removeFromSuperview];
                       [trashAnimator removeBehavior:push];
                     }];
  }

  // Remove the old view
  [self.defaultBehavior removeItem:view];
  [view removeFromSuperview];
}

- (NSArray *)sliceView:(UIView *)view intoRows:(NSUInteger)rows columns:(NSInteger)columns {
  UIGraphicsBeginImageContext(view.bounds.size);
  [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
  CGImageRef image = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
  UIGraphicsEndImageContext();

  NSMutableArray *views = [NSMutableArray new];
  CGFloat width = CGImageGetWidth(image);
  CGFloat height = CGImageGetHeight(image);
  for (NSUInteger row = 0; row < rows; ++row) {
    for (NSUInteger column = 0; column < columns; ++column) {
      CGRect rect = CGRectMake(column * (width / columns),
                               row * (height / rows),
                               width / columns,
                               height / rows);
      CGImageRef subimage = CGImageCreateWithImageInRect(image, rect);
      UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:subimage]];
      CGImageRelease(subimage); subimage = NULL;

      imageView.frame = CGRectOffset(rect,
                                     CGRectGetMinX(view.frame),
                                     CGRectGetMinY(view.frame));
      [views addObject:imageView];
    }
  }

  return views;
}

@end
