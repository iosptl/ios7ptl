//
//  PTLColumnTextViewController.m
//  TextLayout
//
//  Created by Rob Napier on 7/26/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PTLColumnTextViewController.h"

@interface PTLColumnTextViewController ()
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, strong) NSTextStorage *textStorage;
@property (nonatomic, readwrite, strong) NSMutableArray *textViews;
@property (nonatomic, readwrite, strong) UIView *containerView;
@property (nonatomic, readwrite, strong) UIButton *addExclusionButton;

@end

@implementation PTLColumnTextViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // FIXME: Move to IB when IB stops crashing
  self.addExclusionButton = ({
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Add Exclusion" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(performAddExclusion:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    button.backgroundColor = [UIColor greenColor];
    button;
  });

  self.containerView = [UIView new];
  self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.containerView.backgroundColor = [UIColor redColor];
  [self.view addSubview:self.containerView];

  {
    NSDictionary *views = @{
                            @"button": self.addExclusionButton,
                            @"container": self.containerView
                            };

    NSDictionary *metrics = @{
                              @"buttonHeight": @([self.addExclusionButton intrinsicContentSize].height)
                              };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[container]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button(buttonHeight)]-[container]-|" options:0 metrics:metrics views:views]];
  }

  NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Lorem" ofType:@"txt"]
                                             encoding:NSUTF8StringEncoding
                                                error:nil];

  self.textStorage = [[NSTextStorage alloc] initWithString:text];
  self.layoutManager = [[NSLayoutManager alloc] init];

  [self.textStorage addLayoutManager:self.layoutManager];

  UITextView* textView = [UITextView new];
  [textView setTranslatesAutoresizingMaskIntoConstraints:NO];

  [textView scrollRangeToVisible:NSMakeRange(0, 0)];
//  textView.scrollEnabled = NO;
  textView.backgroundColor = [UIColor blueColor];

  [self.containerView addSubview:textView];

  self.textViews = [NSMutableArray arrayWithObject:textView];
  [self.layoutManager addTextContainer:textView.textContainer];

  {
    NSDictionary *views = NSDictionaryOfVariableBindings( textView );
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-|" options:0 metrics:nil views:views]];
  }
}

- (IBAction)performAddExclusion:(id)sender {
}

@end
