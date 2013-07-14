//
//  MKMasterViewController.m
//  MKDrawerDemo
//
//  Created by Mugunth on 25/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "MKMasterViewController.h"

#import "MKControlsCell.h"

@interface MKMasterViewController ()

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) MKControlsCell *controlsCell;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation MKMasterViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.objects =  @[@"USA", @"Europe", @"Singapore", @"Japan",
  @"Australia", @"New Zealand", @"Germany", @"UK",
  @"Melbourne", @"Sydney", @"San Francisco", @"Los Angeles", @"New York", @"London",
  @"Tokyo", @"Paris", @"Milan"];
  
  
  NSArray *nib = [[UINib nibWithNibName:@"MKControlsCell" bundle:nil] instantiateWithOwner:self options:nil];
  self.controlsCell = (MKControlsCell*)[nib objectAtIndex:0];
  self.selectedIndexPath = nil;
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(self.selectedIndexPath)
    return self.objects.count + 1;
  else
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(self.selectedIndexPath.row == indexPath.row && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath) {
    
    return self.controlsCell;
  } else {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(self.selectedIndexPath && self.selectedIndexPath.row < indexPath.row)
      cell.textLabel.text = self.objects[indexPath.row-1];
    else
      cell.textLabel.text = self.objects[indexPath.row];
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  double delayInSeconds = 0.0;
  BOOL shouldAdjustInsertedRow = YES;
  if(self.selectedIndexPath) {
    NSArray *indexesToDelete = @[self.selectedIndexPath];
    if(self.selectedIndexPath.row <= indexPath.row)
      shouldAdjustInsertedRow = NO;
    self.selectedIndexPath = nil;
    delayInSeconds = 0.2;
    [tableView deleteRowsAtIndexPaths:indexesToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
  }

  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    if(shouldAdjustInsertedRow)
      self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    else
      self.selectedIndexPath = indexPath;
    [tableView insertRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  });
}

@end
