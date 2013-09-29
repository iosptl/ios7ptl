//
//  ViewController.m
//  MassiveSort
//
//  Created by Rob Napier on 9/29/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "MassiveSorter.h"
#import "RNTimer.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) CFAbsoluteTime timerStartTime;
@property (nonatomic) RNTimer *timer;
@end

@implementation ViewController

const long kCount = 10000000;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGenerate];
}

- (void)startGenerate {
  NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *path = [docDir stringByAppendingPathComponent:@"infile"];
  MassiveSorter *sorter = [MassiveSorter new];

  self.activityLabel.text = @"Generate";
  
  [self restartTimer];
  [sorter generateRandomFileAtPath:path count:kCount handler:^(CGFloat progress, BOOL done) {
    [self.progressView setProgress:progress];
    if (done) {
      [self stopTimer];
      [self startSortFile];
    }
  }];
}

- (NSString *)elapsedTimeString {
  long elapsedSeconds = (long)(CFAbsoluteTimeGetCurrent() - self.timerStartTime);
  long m = (elapsedSeconds / 60);
  long s = elapsedSeconds % 60;
  return [NSString stringWithFormat:@"%02ld:%02ld", m, s];
}

- (void)restartTimer {
  self.timerStartTime = CFAbsoluteTimeGetCurrent();
  self.timer = [RNTimer repeatingTimerWithTimeInterval:1 block:^{
    self.timerLabel.text = [self elapsedTimeString];
  }];
}

- (void)stopTimer {
  NSLog(@"%@:%@", self.activityLabel.text, [self elapsedTimeString]);
  self.timer = nil;
}

- (void)startSortFile {}

@end
