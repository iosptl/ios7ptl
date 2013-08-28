//
//  ViewController.m
//  CircleLayout
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "PathTextContainer.h"

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

  CGRect textViewFrame = CGRectMake(30, 40, 708, 400);
  PathTextContainer *textContainer = [[PathTextContainer alloc] initWithSize:textViewFrame.size];

  CGRect firstArea = CGRectMake(0, 0,
                                  CGRectGetWidth(textViewFrame) / 2,
                                  CGRectGetHeight(textViewFrame));

  CGRect secondArea = CGRectMake(CGRectGetMaxX(firstArea),
                                   CGRectGetMinY(firstArea),
                                   CGRectGetWidth(firstArea),
                                   CGRectGetHeight(firstArea));

  textContainer.inclusionPaths = @[ [UIBezierPath bezierPathWithOvalInRect:firstArea],
                                    [UIBezierPath bezierPathWithRoundedRect:secondArea
                                                               cornerRadius:100]
                                    ];
  textContainer.exclusionPaths = @[ [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 75, 125, 125)]];

  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];
  textView.allowsEditingTextAttributes = YES;

  // These kinds of settings must be applied after assigning to the UITextView, since UITextView will try to override them.
  layoutManager.allowsNonContiguousLayout = NO; // Otherwise UITextView may get confused during editing.
  layoutManager.hyphenationFactor = 1.0;

  [self.view addSubview:textView];
}

@end
