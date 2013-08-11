//
//  ViewController.m
//  TextLayout
//
//  Created by Rob Napier on 8/8/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "TextLayoutViewController.h"

@interface TextLayoutViewController ()
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, strong) NSArray *lastConstraints;
@end

@implementation TextLayoutViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.layoutManager = [NSLayoutManager new];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
  [textStorage addLayoutManager:self.layoutManager];

  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
  [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
  scrollView.scrollEnabled = YES;
  self.scrollView = scrollView;
  [self.view addSubview:scrollView];

  NSDictionary *views = NSDictionaryOfVariableBindings( scrollView );
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[scrollView]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[scrollView]-|" options:0 metrics:nil views:views]];

  [self layoutPage:0];
  [self layoutPage:1];
}

- (void)layoutPage:(NSUInteger)page {
  UIView *pageView = [[UIView alloc] initWithFrame:CGRectZero];
  [pageView setTranslatesAutoresizingMaskIntoConstraints:NO];

  UITextView *textView1 = [self newViewWithLayoutManager:self.layoutManager];
  [pageView addSubview:textView1];

  UITextView *textView2 = [self newViewWithLayoutManager:self.layoutManager];
  [pageView addSubview:textView2];

  NSDictionary *views = @{ @"textView1": textView1,
                           @"textView2": textView2,
                           @"page": pageView,
                           @"scrollview": self.scrollView};

  [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView1]-[textView2(==textView1)]-|" options:0 metrics:nil views:views]];
  [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView1]-|" options:0 metrics:nil views:views]];
  [pageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView2]-|" options:0 metrics:nil views:views]];

  [self.scrollView addSubview:pageView];

  if (page == 0) {
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[page]" options:0 metrics:nil views:views]];
  }
  else {
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousPage][page]" options:0 metrics:nil views:
                                     @{@"page": pageView,
                                       @"previousPage": self.scrollView.subviews[page-1]}]];
  }
  [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[page(==scrollview)]" options:0 metrics:nil views:views]];
  [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[page(==scrollview)]|" options:0 metrics:nil views:views]];

  if (self.lastConstraints) {
    [self.scrollView removeConstraints:self.lastConstraints];
  }
  self.lastConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[page]|" options:0 metrics:nil views:views];
  [self.scrollView addConstraints:self.lastConstraints];

}

- (UITextView *)newViewWithLayoutManager:(NSLayoutManager *)layoutManager {
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
  [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [textView setScrollEnabled:NO];
  [textView setEditable:NO];
  return textView;
}

@end
