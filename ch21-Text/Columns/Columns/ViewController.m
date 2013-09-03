//
//  ViewController.m
//  Columns
//
//  Created by Rob Napier on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "ColumnView.h"

@implementation ViewController

static NSString *  kLipsum;

+ (void)initialize
{
	if ([self class] == [ViewController class]) {
    NSString *path = [[NSBundle mainBundle] 
                      pathForResource:@"Lipsum" ofType:@"txt"];
		kLipsum = [[NSString alloc] 
               initWithContentsOfFile:path
               encoding:NSUTF8StringEncoding
               error:NULL];
	}
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  CTTextAlignment kAlignment = kCTJustifiedTextAlignment;
	CTParagraphStyleSetting paragraphSettings[] =
	{
		{ kCTParagraphStyleSpecifierAlignment, sizeof(kAlignment), &kAlignment}
	};
  
  id style = (__bridge_transfer id)
  CTParagraphStyleCreate(paragraphSettings, 
                         sizeof(paragraphSettings));
	
  id key = (__bridge id)kCTParagraphStyleAttributeName;
  
	NSDictionary *
  attributes = [NSDictionary dictionaryWithObject:style forKey:key];
	
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:kLipsum attributes:attributes];
  
  ColumnView *columnView = [[ColumnView alloc] initWithFrame:self.view.bounds];
  
	columnView.attributedString = attrString;
  
  [self.view addSubview:columnView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

@end
