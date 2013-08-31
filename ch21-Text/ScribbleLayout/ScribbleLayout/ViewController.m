//
//  ViewController.m
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "ScribbleLayoutManager.h"
#import "ScribbleTextStorage.h"

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

  ScribbleTextStorage *text = [[ScribbleTextStorage alloc] init];
  text.tokens = @{ @"France" : @{ NSForegroundColorAttributeName : [UIColor blueColor] },
                   @"England" : @{ NSForegroundColorAttributeName : [UIColor redColor] },
                   @"season" : @{ RedactStyleAttributeName : @YES },
                   @"and" : @{ HighlightColorAttributeName : [UIColor yellowColor] },

                   DefaultTokenName : @{
                       NSParagraphStyleAttributeName: style,
                       NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]
                       }};

  [text setAttributedString:[[NSAttributedString alloc] initWithString:string]];

  ScribbleLayoutManager *layoutManager = [ScribbleLayoutManager new];

  [text addLayoutManager:layoutManager];

  CGRect textViewFrame = CGRectMake(30, 40, 708, 400);
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:textViewFrame.size];

  [layoutManager addTextContainer:textContainer];

  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];

  [self.view addSubview:textView];
}


@end
