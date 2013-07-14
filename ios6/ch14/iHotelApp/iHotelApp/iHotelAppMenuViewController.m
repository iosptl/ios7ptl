//
//  iHotelAppMenuViewController.m
//  iHotelApp
//
//  Created by Mugunth on 28/6/12.
//  Copyright (c) 2012 Steinlogic. All rights reserved.
//

#import "iHotelAppMenuViewController.h"
#import "MenuItem.h"
#import "iHotelAppAppDelegate.h"

@interface iHotelAppMenuViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@end

@implementation iHotelAppMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  self.title = NSLocalizedString(@"Menu", @"");
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated {
  
  [AppDelegate.engine fetchMenuItemsOnSucceeded:^(NSMutableArray *listOfModelBaseObjects) {
    
    self.menuItems = listOfModelBaseObjects;
    [self.tableView reloadData];
  } onError:^(NSError *engineError) {
    [UIAlertView showWithError:engineError];
  }];
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.menuItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  MenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
  cell.textLabel.text = item.name;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
	
}

@end
