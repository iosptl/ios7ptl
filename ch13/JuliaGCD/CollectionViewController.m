//
//  CollectionViewController.m
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "CollectionViewController.h"
#import "JuliaCell.h"

@interface CollectionViewController ()
//@property (nonatomic, readwrite, strong) NSOperationQueue *queue;
@end

@implementation CollectionViewController

//- (void)viewDidLoad
//{
//  [super viewDidLoad];
//  self.queue = [[NSOperationQueue alloc] init];
//  self.queue.maxConcurrentOperationCount = 2; // NOTE ME
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1000;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = @"Julia";
  JuliaCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  [cell configureWithSeed:indexPath.row]; // queue:self.queue];
  return cell;
}

@end
