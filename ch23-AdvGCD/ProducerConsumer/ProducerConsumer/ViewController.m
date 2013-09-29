//
//  ViewController.m
//  ProducerConsumer
//
//  Created by Rob Napier on 9/29/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *inQueueLabel;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) dispatch_queue_t waitQueue;
@property (nonatomic) dispatch_queue_t workQueue;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *progressViews;
@property (nonatomic) NSUInteger _inQueue;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.semaphore = dispatch_semaphore_create([self.progressViews count]);
  self.waitQueue = dispatch_queue_create("ProducerConsumer.wait", DISPATCH_QUEUE_SERIAL);
  self.workQueue = dispatch_queue_create("ProducerConsumer.work", DISPATCH_QUEUE_CONCURRENT);
}

- (void)adjustInQueueBy:(NSInteger)value {
  dispatch_async(dispatch_get_main_queue(), ^{
    __inQueue += value;
    self.inQueueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)__inQueue];
  });
}

- (UIProgressView *)reserveProgressView {
  __block UIProgressView *availableProgressView;
  dispatch_sync(dispatch_get_main_queue(), ^{
    for (UIProgressView *progressView in self.progressViews) {
      if (progressView.isHidden) {
        availableProgressView = progressView;
        break;
      }
    }
    availableProgressView.hidden = NO;
    availableProgressView.progress = 0;
  });

  NSAssert(availableProgressView, @"There should always be one available here.");
  return availableProgressView;
}

- (void)releaseProgressView:(UIProgressView *)progressView {
  dispatch_async(dispatch_get_main_queue(), ^{
    progressView.hidden = YES;
  });
}

- (IBAction)runProcess:(UIButton *)button {
  [self adjustInQueueBy:1];
  dispatch_async(self.waitQueue, ^{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    UIProgressView *availableProgressView = [self reserveProgressView];

    dispatch_async(self.workQueue, ^{
      [self performWorkWithProgressView:availableProgressView];
      [self releaseProgressView:availableProgressView];
      [self adjustInQueueBy:-1];
      dispatch_semaphore_signal(self.semaphore);
    });
  });
}

- (void)performWorkWithProgressView:(UIProgressView *)progressView {
  for (NSUInteger p = 0; p <= 100; ++p) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      progressView.progress = p/100.0;
    });
    usleep(50000);
  }
}

@end
