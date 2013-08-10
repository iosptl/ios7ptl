//
//  DataViewController.m
//  PageLayout
//
//  Created by Rob Napier on 8/10/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
@property (readwrite, weak, nonatomic) IBOutlet UITextView *textView;
@property (readwrite, weak, nonatomic) IBOutlet UILabel *pageLabel;
@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pageLabel.text = [NSString stringWithFormat:@"Page: %d", self.pageNumber];
}

@end
