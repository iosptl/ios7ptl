//
//  MasterViewController.m
//  iOS6PullToRefresh
//
//  Created by Mugunth on 9/7/12.
//  Copyright (c) 2012 Mugunth. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () {
  NSMutableArray *_objects;
}

@end

@implementation MasterViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = NSLocalizedString(@"Pull to refresh", @"");
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) doRefresh {
  
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    self.loading = NO;
  });
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  // Configure the cell...
  cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
  
  cell.imageView.image = [UIImage imageNamed:@"iOS6"];
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

@end
