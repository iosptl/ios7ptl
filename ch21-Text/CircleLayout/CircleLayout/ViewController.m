//
//  ViewController.m
//  CircleLayout
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
//#import "CircleTextContainer.h"
#import "PathTextContainer.h"
#import "LayoutView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  [style setAlignment:NSTextAlignmentJustified];

  NSTextStorage *text = [[NSTextStorage alloc] initWithString:string
                                                   attributes:@{NSParagraphStyleAttributeName: style}];
  NSLayoutManager *layoutManager = [NSLayoutManager new];
  [text addLayoutManager:layoutManager];

  CGRect textViewFrame = CGRectMake(40, 40, 400, 400);
  PathTextContainer *textContainer = [[PathTextContainer alloc] initWithSize:textViewFrame.size];
  textContainer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 400, 400)];

  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];


  [self.view addSubview:textView];
}

@end
