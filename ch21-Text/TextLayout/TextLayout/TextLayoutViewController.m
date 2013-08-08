//
//  ViewController.m
//  TextLayout
//
//  Created by Rob Napier on 8/8/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "TextLayoutViewController.h"

@interface TextLayoutViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstColumnTextView;
@property (weak, nonatomic) IBOutlet UIView *secondColumnTextLayoutView;

@end

@implementation TextLayoutViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
  [textStorage addLayoutManager:layoutManager];

  NSTextContainer *textContainer1 = [[NSTextContainer alloc] initWithSize:CGSizeZero];
  [layoutManager addTextContainer:textContainer1];
  UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer1];
  [textView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
  [textView1 setScrollEnabled:NO];
  [textView1 setEditable:NO];
  [self.view addSubview:textView1];

  NSTextContainer *textContainer2 = [[NSTextContainer alloc] initWithSize:CGSizeZero];
  [layoutManager addTextContainer:textContainer2];
  UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer2];
  [textView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
  [textView2 setScrollEnabled:NO];
  [self.view addSubview:textView2];

  NSDictionary *views = NSDictionaryOfVariableBindings( textView1, textView2 );
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView1]-[textView2(==textView1)]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView1]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView2]-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
