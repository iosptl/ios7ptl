//
//  DragViewController.m
//  CollectionDrag
//
//  Created by Rob Napier on 9/20/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DragViewController.h"
#import "DragLayout.h"

@implementation DragViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (IBAction)handleLongPress:(UIGestureRecognizer *)g {
  DragLayout *dragLayout = (DragLayout *)self.collectionViewLayout;
  CGPoint location = [g locationInView:self.collectionView];

  // Find the indexPath and cell being dragged
  NSIndexPath *indexPath = [self.collectionView
                            indexPathForItemAtPoint:location];
  UICollectionViewCell *cell = [self.collectionView
                                cellForItemAtIndexPath:indexPath];

  UIGestureRecognizerState state = g.state;
  if (state == UIGestureRecognizerStateBegan) {
    // Change the color and start dragging
    [UIView animateWithDuration:0.25
                     animations:^{
                       cell.backgroundColor = [UIColor redColor];
                     }];
    [dragLayout startDraggingIndexPath:indexPath fromPoint:location];
  }

  else if (state == UIGestureRecognizerStateEnded ||
           state == UIGestureRecognizerStateCancelled) {
    // Change the color and stop dragging
    [UIView animateWithDuration:0.25
                     animations:^{
                       cell.backgroundColor = [UIColor lightGrayColor];
                     }];
    [dragLayout stopDragging];
  }

  else {
    // Drag
    [dragLayout updateDragLocation:location];
  }
}

@end
