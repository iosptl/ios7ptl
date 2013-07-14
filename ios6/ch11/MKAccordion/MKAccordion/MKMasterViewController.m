//
//  MKMasterViewController.m
//  MKAccordion
//
//  Created by Mugunth on 24/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "MKMasterViewController.h"

#import "MKAccordionButton.h"

@interface MKMasterViewController ()
@property (strong, nonatomic) NSDictionary *objects;
@property (nonatomic, assign) int currentlyExpandedIndex;
@end

@implementation MKMasterViewController

-(void) openAccordionAtIndex:(int) index {
  
  NSMutableArray *indexPaths = [NSMutableArray array];
  
  int sectionCount = [[self.objects objectForKey:[[self.objects allKeys] objectAtIndex:self.currentlyExpandedIndex]] count];
  
  for(int i = 0; i < sectionCount; i ++) {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:self.currentlyExpandedIndex];
    [indexPaths addObject:indexPath];
  }
  
  self.currentlyExpandedIndex = -1;
  
  [self.tableView deleteRowsAtIndexPaths:indexPaths
                        withRowAnimation:UITableViewRowAnimationTop];
  
  self.currentlyExpandedIndex = index;
  
  sectionCount = [[self.objects objectForKey:[[self.objects allKeys] objectAtIndex:self.currentlyExpandedIndex]] count];
  
  [indexPaths removeAllObjects];
  for(int i = 0; i < sectionCount; i ++) {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:self.currentlyExpandedIndex];
    [indexPaths addObject:indexPath];
  }
  
  double delayInSeconds = 0.35;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  });
  
  [self.tableView endUpdates];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.objects = @{
  @"News" : @[@"USA", @"Europe", @"Singapore", @"Japan"],
  @"Technology" : @[@"Apple", @"Microsoft", @"Google", @"Samsung"],
  @"Sports" : @[@"Baseball", @"Softball", @"Rubgy", @"Golf"]
  };
  
  [self.tableView reloadData];
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
  return [[self.objects allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if(self.currentlyExpandedIndex == section) {
    NSString *key = [[self.objects allKeys] objectAtIndex:section];
    return [[self.objects objectForKey:key] count];
  }
  else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  NSString *str = [[self.objects objectForKey:[[self.objects allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  cell.textLabel.text = str;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  MKAccordionButton *button = [[[UINib nibWithNibName:@"MKAccordionButton" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
	
  [button.mainButton setTitle:[[self.objects allKeys] objectAtIndex:section]
                     forState:UIControlStateNormal];
  
  button.buttonTappedHandler = ^{
    
    [self openAccordionAtIndex:section];
  };
  
  return button;
}
@end
