//
//  FirstViewController.m
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readwrite, strong) NSArray *allColumns;
@property (nonatomic, readwrite, strong) NSMutableArray *displayColumns;
@end

@implementation DataViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.allColumns = @[ @"firstName", @"lastName", @"age" ];
  self.displayColumns = [self.allColumns mutableCopy];
  [self updateData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    [self.displayColumns removeObject:self.allColumns[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  else {
    [self.displayColumns addObject:self.allColumns[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }

  [self updateData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.allColumns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"ColumnHeader";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  if (! cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }

  cell.textLabel.text = self.allColumns[indexPath.row];
  return cell;
}

- (void)updateData {
  NSLog(@"%@", self.displayColumns);
}

@end
