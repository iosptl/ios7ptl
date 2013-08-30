//
//  ViewController.m
//  CurvyText
//
//  Created by Rob Napier on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CurvyTextView.h"
#import <CoreText/CoreText.h>

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  CurvyTextView *curvyTextView = [[CurvyTextView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:curvyTextView];
  
  NSString *string = @"You can display text along a curve, with bold, color, and big text.";
  
  NSMutableAttributedString *
  attrString = [[NSMutableAttributedString alloc]
                initWithString:string
                attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0],
                } ];
    
  [attrString addAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:16] }
                      range:[string rangeOfString:@"bold"]];
  
  [attrString addAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }
                      range:[string rangeOfString:@"color"]];

  [attrString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:32] }
                      range:[string rangeOfString:@"big text"]];
  
  curvyTextView.attributedString = attrString;
}

@end
