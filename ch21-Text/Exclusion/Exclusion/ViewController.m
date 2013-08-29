//
//  ViewController.m
//  Exclusion
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample.txt" ofType:nil];
  NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  self.textView.text = string;
  self.textView.textAlignment = NSTextAlignmentJustified;

  CGRect bounds = self.view.bounds;
  CGFloat width = CGRectGetWidth(bounds);
  CGFloat height = CGRectGetHeight(bounds);
  CGRect rect = CGRectInset(bounds,
                            width/4,
                            height/4);
  UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                           cornerRadius:width/10];
  self.textView.textContainer.exclusionPaths = @[exclusionPath];
}


@end
