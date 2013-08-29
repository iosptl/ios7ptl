//
//  SCTViewController.m
//  CollectionViewCustomTransitionDemo
//
//  Created by Mugunth on 20/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTCollection1ViewController.h"

#import "SCTCollection2ViewController.h"

@interface SCTCollection1ViewController ()

@end

@implementation SCTCollection1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  SCTCollection2ViewController *controller = segue.destinationViewController;
  controller.useLayoutToLayoutNavigationTransitions = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  
  return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                  forIndexPath:indexPath];
  
  return cell;
}

@end
