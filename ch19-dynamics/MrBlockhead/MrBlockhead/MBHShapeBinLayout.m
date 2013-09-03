//
//  MBHShapeBinLayout.m
//  MrBlockhead
//
//  Created by Rob Napier on 9/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MBHShapeBinLayout.h"
#import "MBHTearOffBehavior.h"

@interface MBHShapeBinLayout ()
@property (nonatomic, readwrite, strong) UIDynamicAnimator *animator;
@property (nonatomic, readwrite, strong) NSIndexPath *draggedIndexPath;
@property (nonatomic, readwrite, strong) MBHTearOffBehavior *behavior;

@end
@implementation MBHShapeBinLayout

- (void)startDraggingIndexPath:(NSIndexPath *)indexPath fromPoint:(CGPoint)p {
  NSLog(@"startDragging");
  self.draggedIndexPath = indexPath;
  self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];

  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
  attributes.zIndex = 1;

  self.behavior = [[MBHTearOffBehavior alloc] initWithItem:attributes attachedToAnchor:p];
  [self.animator addBehavior:self.behavior];
}

- (void)updateDragLocation:(CGPoint)p {
  [self.behavior setAnchorPoint:p];
}

- (void)clearDraggedIndexPath {
  self.animator = nil;
  self.draggedIndexPath = nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *existingAttributes = [super layoutAttributesForElementsInRect:rect];
  NSMutableArray *allAttributes = [NSMutableArray array];
  for (UICollectionViewLayoutAttributes *attributes in existingAttributes) {
    if (![attributes.indexPath isEqual:self.draggedIndexPath]) {
      [allAttributes addObject:attributes];
    }
  }

  [allAttributes addObjectsFromArray:[self.animator itemsInRect:rect]];
  return allAttributes;
}
@end
