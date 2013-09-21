//
//  ViewController.m
//  ZipText
//
//  Created by Rob Napier on 7/15/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "ZipTextView.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *
  path = [[NSBundle mainBundle] pathForResource:@"Lorem"
                                         ofType:@"txt"];
  
  ZipTextView *ztView = [[ZipTextView alloc]
                         initWithFrame:self.view.bounds
                         text:[NSString stringWithContentsOfFile:path
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil]];
  [self.view addSubview:ztView];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}
@end
