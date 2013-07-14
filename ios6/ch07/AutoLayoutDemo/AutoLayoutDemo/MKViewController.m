//
//  MKViewController.m
//  AutoLayoutDemo
//
//  Created by Mugunth on 5/9/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training. All rights reserved.
//

#import "MKViewController.h"

@interface MKViewController ()
@property (strong, nonatomic) IBOutlet UIButton *myButton;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@end

@implementation MKViewController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
