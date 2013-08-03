//
//  FirstViewController.m
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DataViewController.h"
#import "PersonManager.h"
#import "TextDataCell.h"
#import "Person.h"
#import "HeadingView.h"

@interface DataViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource>
@property (nonatomic, readwrite, strong) NSArray *allColumns;
@property (nonatomic, readwrite, strong) NSMutableArray *displayColumns;
@property (weak, nonatomic) IBOutlet UICollectionView *dataView;
@end

@implementation DataViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.allColumns = @[ @"firstName", @"lastName", @"age" ];
  self.displayColumns = [self.allColumns mutableCopy];
}

- (void)updateItemSize {
  UICollectionViewFlowLayout *layout = (id)self.dataView.collectionViewLayout;
  layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / ([self.displayColumns count] + 1),
                               layout.itemSize.height);
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

  [self updateItemSize];
  [self.dataView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.allColumns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColumnHeader" forIndexPath:indexPath];
  cell.textLabel.text = self.allColumns[indexPath.row];
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.personManager count] * [self.displayColumns count];

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TextDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Person" forIndexPath:indexPath];

  NSUInteger personIndex = (int)(indexPath.row / [self.displayColumns count]);
  Person *person = [self.personManager personAtIndex:personIndex];
  cell.label.text = [[person valueForKey:self.displayColumns[indexPath.row % [self.displayColumns count]]] description];
  return cell;
}

- (void)viewWillLayoutSubviews {
  [self updateItemSize];
}

@end
