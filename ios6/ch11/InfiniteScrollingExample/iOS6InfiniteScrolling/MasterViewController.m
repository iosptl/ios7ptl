//
//  MasterViewController.m
//  iOS6PullToRefresh
//
//  Created by Mugunth on 9/7/12.
//  Copyright (c) 2012 Mugunth. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
@property (assign, nonatomic) int pageCount;
@end

@implementation MasterViewController
@synthesize pageCount = _pageCount;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.numberOfSections = 1;
  self.pageCount = 1;
  self.title = NSLocalizedString(@"Infinite Scrolling", @"");
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

-(void) loadMore {
  
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    self.pageCount ++;
    if(self.pageCount == 5) self.endReached = YES;
    [self.tableView reloadData];
  });
}
#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if(section == self.numberOfSections)  {
    return [super tableView:tableView numberOfRowsInSection:section];
  }
  return 20 * self.pageCount;
}


// table with with built in cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section == self.numberOfSections)  {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  }
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
