//
//  ViewController.m
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "PTLScribbleLayoutManager.h"
#import "PTLScribbleTextStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Create the attributed string
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string];

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  [style setAlignment:NSTextAlignmentJustified];

  // Create the text storage
  PTLScribbleTextStorage *text = [[PTLScribbleTextStorage alloc] init];

  text.tokens = @{ @"France" : @{ NSForegroundColorAttributeName :
                                    [UIColor blueColor] },
                   @"England" : @{ NSForegroundColorAttributeName :
                                     [UIColor redColor] },
                   @"season" : @{PTLRedactStyleAttributeName :
                                   @YES },
                   @"and" : @{PTLHighlightColorAttributeName :
                                [UIColor yellowColor] },

                   PTLDefaultTokenName : @{
                       NSParagraphStyleAttributeName: style,
                       NSFontAttributeName:
                         [UIFont
                          preferredFontForTextStyle:UIFontTextStyleCaption2]
                       } };

  [text setAttributedString:attributedString];

  // Create the layout manager
  PTLScribbleLayoutManager *layoutManager = [PTLScribbleLayoutManager new];
  [text addLayoutManager:layoutManager];

  // Create the text container
  CGRect textViewFrame = CGRectMake(30, 40, 708, 400);
  NSTextContainer *
  textContainer = [[NSTextContainer alloc] initWithSize:textViewFrame.size];
  [layoutManager addTextContainer:textContainer];

  // Create the text view
  UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                             textContainer:textContainer];
  [self.view addSubview:textView];
}


@end
