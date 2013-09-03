//
//  MBHShapeBinViewController.m
//  MrBlockhead
//
//  Created by Rob Napier on 9/2/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MBHShapeBinViewController.h"
#import "MBHShapeCell.h"
#import "UIBezierPath+MBH.h"
#import "MBHShapeBinLayout.h"

@interface MBHShapeBinViewController ()
@property (nonatomic, readwrite, strong) NSArray *shapes;
@property (nonatomic, readonly) MBHShapeBinLayout *binLayout;
@end

@implementation MBHShapeBinViewController

- (void)awakeFromNib {
  CGFloat kShapeDimension = 100;
  CGFloat kShapeInset = 10;

  CGSize kShapeSize = { .height = kShapeDimension, .width = kShapeDimension };
  CGRect layerFrame = { .origin = CGPointZero, .size = kShapeSize };
  CGRect shapeFrame = CGRectInset(layerFrame, kShapeInset, kShapeInset);

  self.shapes = [UIBezierPath mbh_assortedBezierPathsInRect:shapeFrame
                                              withSelectors:
                 @selector(bezierPathWithOvalInRect:),
                 @selector(bezierPathWithRect:),
                 @selector(mbh_bezierPathWithTriangleInRect:),
                 nil];

  [(MBHShapeBinLayout *)self.binLayout setItemSize:kShapeSize];
}

- (MBHShapeBinLayout *)binLayout {
  return (MBHShapeBinLayout *)self.collectionView.collectionViewLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.shapes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MBHShapeCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MBHShapeCell"
                                                                         forIndexPath:indexPath];
  newCell.path = self.shapes[indexPath.row];
  return newCell;
}

- (IBAction)handlePan:(id)sender {
  UIPanGestureRecognizer *g = sender;

  CGPoint point = [g locationInView:self.view];

  NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
  if (indexPath) {
    switch (g.state) {
      case UIGestureRecognizerStateBegan:
        NSLog(@"switch StartDragging: %@", self.binLayout);
        [self.binLayout startDraggingIndexPath:indexPath fromPoint:point];
        break;
      case UIGestureRecognizerStateChanged:
        [self.binLayout updateDragLocation:point];
        break;
      case UIGestureRecognizerStateEnded:
        [self.binLayout clearDraggedIndexPath];
        break;
      case UIGestureRecognizerStateCancelled:
        [self.binLayout clearDraggedIndexPath];
        break;
      default:
        break;
    }
  }
}

@end
