//
//  ViewController.m
//  SimpleOperation
//
//  Created by Rob Napier on 8/15/11.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, readwrite, weak) IBOutlet UILabel *label;
@property (nonatomic, readwrite, assign) NSUInteger count;
@property (nonatomic, readwrite, strong) NSOperationQueue *queue;
@end

@implementation ViewController

- (void)addNextOperation {
  __weak typeof(self) weakSelf = self;
  NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:1];
    weakSelf.count = weakSelf.count + 1;
  }];
  op.completionBlock = ^{[weakSelf addNextOperation];};
  
  [self.queue addOperation:op];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.queue = [[NSOperationQueue alloc] init];
  self.count = 0;
  [self addNextOperation];
}

- (void)setCount:(NSUInteger)count {
  _count = count;
  __weak typeof(self) weakSelf = self;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    weakSelf.label.text = [NSString stringWithFormat:@"%d", count];
  }];
}

- (void)viewWillDisappear:(BOOL)animated {
  self.queue.suspended = YES;
  self.queue = nil;
  [super viewWillDisappear:animated];
}


@end
