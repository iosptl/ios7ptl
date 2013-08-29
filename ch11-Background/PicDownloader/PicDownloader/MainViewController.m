//
//  PTLViewController.m
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MainViewController.h"
#import "PictureCollection.h"
#import "PictureCell.h"

@interface MainViewController ()
- (IBAction)reset:(id)sender;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
  [self.pictureCollection addObserver:self forKeyPath:@"count" options:0 context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self.pictureCollection removeObserver:self forKeyPath:@"count"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.pictureCollection.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PictureCell *cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
  [cell setPicture:[self.pictureCollection pictureAtIndex:indexPath.row]];

  return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
  });
}

- (IBAction)reset:(id)sender {
  [[self pictureCollection] reset];
}
@end
