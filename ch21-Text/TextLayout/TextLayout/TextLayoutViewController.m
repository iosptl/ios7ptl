//
//  ViewController.m
//  TextLayout
//
//  Created by Rob Napier on 8/8/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "TextLayoutViewController.h"

@interface TextLayoutViewController ()
@end

@implementation TextLayoutViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSLayoutManager *layoutManager = [NSLayoutManager new];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
  [textStorage addLayoutManager:layoutManager];

  UITextView *textView1 = [self newViewWithLayoutManager:layoutManager];
  [self.view addSubview:textView1];

  UITextView *textView2 = [self newViewWithLayoutManager:layoutManager];
  [self.view addSubview:textView2];

  NSDictionary *views = NSDictionaryOfVariableBindings( textView1, textView2 );
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView1]-[textView2(==textView1)]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView1]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView2]-|" options:0 metrics:nil views:views]];
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
