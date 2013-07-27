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
@property (nonatomic, readwrite, strong) NSTextContainer *textContainer;
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
    button;
  });

  self.containerView = [UIView new];
  self.containerView.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:self.containerView];

  {
    NSDictionary *views = @{
                            @"button": self.addExclusionButton,
                            @"container": self.containerView
                            };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[container]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button]-[container]-|" options:0 metrics:nil views:views]];
  }

  NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Lorem" ofType:@"txt"]
                                             encoding:NSUTF8StringEncoding
                                                error:nil];

  NSTextStorage* textStorage = [[NSTextStorage alloc] initWithString:text];
  self.layoutManager = ({
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    self.textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    [layoutManager addTextContainer:self.textContainer];
    layoutManager;
  });

  UITextView* textView = [[UITextView alloc] initWithFrame:self.view.bounds
                                             textContainer:self.textContainer];
  [textView setTranslatesAutoresizingMaskIntoConstraints:NO];

  [textView scrollRangeToVisible:NSMakeRange(0, 0)];
  textView.scrollEnabled = NO;

  [self.containerView addSubview:textView];


  self.textViews = [NSMutableArray arrayWithObject:textView];

  {
    NSDictionary *views = NSDictionaryOfVariableBindings( textView );
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-|" options:0 metrics:nil views:views]];
  }
}

- (IBAction)performAddExclusion:(id)sender {
}

@end
