//
//  ViewController.m
//  CircleLayout
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
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
                                                   attributes:@{
                                                                NSParagraphStyleAttributeName: style,
                                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                                                }];
  NSLayoutManager *layoutManager = [NSLayoutManager new];
  [text addLayoutManager:layoutManager];

  CGRect textViewFrame = CGRectMake(30, 40, 708, 344);
  PathTextContainer *textContainer = [[PathTextContainer alloc] initWithSize:textViewFrame.size];

  CGRect firstCircle = CGRectMake(0, 0,
                                  CGRectGetWidth(textViewFrame) / 2,
                                  CGRectGetHeight(textViewFrame));

  CGRect secondCircle = CGRectMake(CGRectGetMaxX(firstCircle),
                                   CGRectGetMinY(firstCircle),
                                   CGRectGetWidth(firstCircle),
                                   CGRectGetHeight(firstCircle));

  textContainer.inclusionPaths = @[ [UIBezierPath bezierPathWithOvalInRect:firstCircle],
                                    [UIBezierPath bezierPathWithOvalInRect:secondCircle]];
  textContainer.exclusionPaths = @[ [UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 100, 100, 100)]];

  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];


  [self.view addSubview:textView];
}

@end
