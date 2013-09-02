//
//  MBHShapeBinViewController.m
//  MrBlockhead
//
//  Created by Rob Napier on 9/2/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MBHShapeBinViewController.h"
#import "MBHShapeCell.h"

@interface MBHShapeBinViewController ()
@property (nonatomic, readwrite, strong) NSArray *shapes;
@end

@implementation MBHShapeBinViewController

- (void)awakeFromNib {
  CGFloat kShapeDimension = 100;
  CGFloat kShapeInset = 10;

  CGSize kShapeSize = { .height = kShapeDimension, .width = kShapeDimension };
  CGRect layerFrame = { .origin = CGPointZero, .size = kShapeSize };
  CGRect shapeFrame = CGRectInset(layerFrame, kShapeInset, kShapeInset);

  self.shapes = @[ [UIBezierPath bezierPathWithOvalInRect:shapeFrame],
                   [UIBezierPath bezierPathWithRect:shapeFrame]
                  ];

  [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize:kShapeSize];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.shapes count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MBHShapeCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MBHShapeCell"
                                                                         forIndexPath:indexPath];

  newCell.path = self.shapes[indexPath.row];
  return newCell;
}


@end
