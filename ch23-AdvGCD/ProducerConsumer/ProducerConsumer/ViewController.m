//
//  ViewController.m
//  ProducerConsumer
//
//  Created by Rob Napier on 9/29/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "RNQueue.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *inQueueLabel;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) dispatch_queue_t pendingQueue;
@property (nonatomic) dispatch_queue_t workQueue;
@property (strong, nonatomic) IBOutletCollection(UIProgressView) NSArray *progressViews;
@property (nonatomic) int _pendingJobCount;  // Should only be accessed through adjustPendingJobCountBy:
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.semaphore = dispatch_semaphore_create([self.progressViews count]);

  self.pendingQueue = RNQueueCreateTagged("ProducerConsumer.pending", DISPATCH_QUEUE_SERIAL);
  self.workQueue = RNQueueCreateTagged("ProducerConsumer.work", DISPATCH_QUEUE_CONCURRENT);
}

- (void)adjustPendingJobCountBy:(NSInteger)value {
  // Safe on any queue
  dispatch_async(dispatch_get_main_queue(), ^{
    self._pendingJobCount += value;
    self.inQueueLabel.text = [NSString stringWithFormat:@"%d", self._pendingJobCount];
  });
}

- (UIProgressView *)reserveProgressView {
  // Make we're on the main queue.
  RNAssertQueue(self.pendingQueue);

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
  RNAssertQueue(self.workQueue);

  dispatch_async(dispatch_get_main_queue(), ^{
    progressView.hidden = YES;
  });
}

- (IBAction)runProcess:(UIButton *)button {
  RNAssertMainQueue();

  // Update the UI to display the number of pending jobs
  [self adjustPendingJobCountBy:1];

  // Dispatch a new work unit to the serial pending queue.
  dispatch_async(self.pendingQueue, ^{
    // Wait for an open slot
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

    // Fetch a an available resource.
    // We're on a serial queue, so we know there is no race condition
    UIProgressView *availableProgressView = [self reserveProgressView];

    // Dispatch actual work to the concurrent work queue
    dispatch_async(self.workQueue, ^{
      // Perform the dummy work
      [self performWorkWithProgressView:availableProgressView];

      // Let go of our resource
      [self releaseProgressView:availableProgressView];

      // Update the UI
      [self adjustPendingJobCountBy:-1];

      // Release our slot so another job can start
      dispatch_semaphore_signal(self.semaphore);
    });
  });
}

- (void)performWorkWithProgressView:(UIProgressView *)progressView {
  RNAssertQueue(self.workQueue);

  for (NSUInteger p = 0; p <= 100; ++p) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      progressView.progress = p/100.0;
    });
    usleep(50000);
  }
}

@end
