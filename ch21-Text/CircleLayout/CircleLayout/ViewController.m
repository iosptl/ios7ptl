//
//  ViewController.m
//  CircleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "CircleTextContainer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  [style setAlignment:NSTextAlignmentJustified];

  NSTextStorage *text = [[NSTextStorage alloc] initWithString:string
                                                   attributes:@{
                                                                NSParagraphStyleAttributeName: style,
                                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]
                                                                }];
  NSLayoutManager *layoutManager = [NSLayoutManager new];
  [text addLayoutManager:layoutManager];

  CGRect textViewFrame = CGRectMake(30, 40, 708, 708);
  CircleTextContainer *textContainer = [[CircleTextContainer alloc] initWithSize:textViewFrame.size];
  [textContainer setExclusionPaths:@[ [UIBezierPath bezierPathWithOvalInRect:CGRectMake(425, 150, 150, 150)]]];

  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];
  textView.allowsEditingTextAttributes = YES;

  [self.view addSubview:textView];
}
@end
