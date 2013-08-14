//
//  DataViewController.m
//  PageLayout
//
//  Created by Rob Napier on 8/10/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
@property (readwrite, strong, nonatomic) UITextView *textView;
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, assign) NSUInteger pageNumber;
@end

@implementation DataViewController

- (instancetype)initWithLayoutManager:(NSLayoutManager *)layoutManager pageNumber:(NSUInteger)pageNumber {
  self = [super init];
  if (self) {
    _layoutManager = layoutManager;
    _pageNumber = pageNumber;
  }
  return self;
}

- (void)loadView {
  self.textView
}

@end