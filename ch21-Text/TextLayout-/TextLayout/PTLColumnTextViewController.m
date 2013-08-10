//
//  PTLColumnTextViewController.m
//  TextLayout
//
//  Created by Rob Napier on 7/26/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PTLColumnTextViewController.h"

@interface PTLColumnTextViewController () <NSLayoutManagerDelegate>
@property (nonatomic, readwrite, strong) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite, strong) NSTextStorage *textStorage;
@property (nonatomic, readwrite, strong) NSMutableArray *textViews;
@property (nonatomic, readwrite, strong) UIView *containerView;
@property (nonatomic, readwrite, strong) UIButton *addExclusionButton;

@end

@implementation PTLColumnTextViewController

- (UITextView *)newTextView
{
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];

  [self.layoutManager addTextContainer:textContainer];
  UITextView* textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
  [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.layoutManager addTextContainer:textContainer];
//  textContainer.maximumNumberOfLines =10;
  NSLog(@"textContainer:%@", textContainer);

//  textContainer.heightTracksTextView = YES;
//  textContainer.widthTracksTextView = YES;

  return textView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Lorem" ofType:@"txt"]
                                             encoding:NSUTF8StringEncoding
                                                error:nil];

  self.textStorage = [[NSTextStorage alloc] initWithString:text];
  self.layoutManager = [[NSLayoutManager alloc] init];
  self.layoutManager.delegate = self;

  [self.textStorage addLayoutManager:self.layoutManager];

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

    NSDictionary *metrics = @{
                              @"buttonHeight": @([self.addExclusionButton intrinsicContentSize].height)
                              };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[container]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button(buttonHeight)]-[container]-|" options:0 metrics:metrics views:views]];
  }

  UITextView *textView1 = [self newTextView];
  [textView1 setScrollEnabled:NO];
  [textView1 setBackgroundColor:[UIColor redColor]];
  [self.containerView addSubview:textView1];

  UITextView *textView2 = [self newTextView];
  [textView1 setScrollEnabled:NO];
  [textView2 setBackgroundColor:[UIColor blueColor]];
  [self.containerView addSubview:textView2];

  self.textViews = [NSMutableArray arrayWithObjects:textView1, textView2, nil];

  {
    NSDictionary *views = NSDictionaryOfVariableBindings( textView1, textView2 );
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView1]-[textView2(==textView1)]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView1]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView2]-|" options:0 metrics:nil views:views]];
  }
}

- (IBAction)performAddExclusion:(id)sender {
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
  NSLog(@"didComplete(%d):%@", layoutFinishedFlag, textContainer );
}



@end
