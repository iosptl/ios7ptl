//
//  ViewController.m
//  SimpleGCD
//
//  Created by Rob Napier on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, readwrite, weak) IBOutlet UILabel *label;
@property (nonatomic, readwrite, assign) NSUInteger count;
@property (nonatomic, readwrite, strong) dispatch_queue_t queue;
@property (nonatomic, readwrite, assign) BOOL shouldRun;
@end

@implementation ViewController {
  NSUInteger _count;
}

- (void)addNextOperation {
  __weak typeof(self) myself = self;
  double delayInSeconds = 1.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 
                                          delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, self.queue, ^(void){
    myself.count = myself.count + 1;
    [self addNextOperation];
  });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.queue = dispatch_queue_create("net.robnapier.SimpleGCD.ViewController",
                                     DISPATCH_QUEUE_CONCURRENT);
  self.count = 0;
  [self addNextOperation];
}

- (void)viewDidUnload {
  dispatch_suspend(self.queue);
  self.queue = nil;
  [self setLabel:nil];
  [super viewDidUnload];
}

- (NSUInteger)count {
  __block NSUInteger count;
	dispatch_sync(self.queue, ^{
		count = _count;
	});
	return count;
}

- (void)setCount:(NSUInteger)count {
  dispatch_barrier_async(self.queue, ^{
    _count = count;
  });
  dispatch_async(dispatch_get_main_queue(), ^{
    self.label.text = [NSString stringWithFormat:@"%d", count];
  });
}

@end
