//
//  DragLayout.m
//  CollectionDrag
//
//  Created by Rob Napier on 9/20/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DragLayout.h"

@interface DragLayout ()
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *behavior;
@end

@implementation DragLayout

- (void)startDraggingIndexPath:(NSIndexPath *)indexPath
                     fromPoint:(CGPoint)p {
  self.indexPath = indexPath;
  self.animator = [[UIDynamicAnimator alloc]
                   initWithCollectionViewLayout:self];

  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:self.indexPath];
  // Raise the item above its peers
  attributes.zIndex += 1;

  self.behavior = [[UIAttachmentBehavior alloc] initWithItem:attributes
                                            attachedToAnchor:p];
  self.behavior.length = 0;
  self.behavior.frequency = 10;
  [self.animator addBehavior:self.behavior];

  // Add a little resistance to keep things stable
  UIDynamicItemBehavior *dynamicItem = [[UIDynamicItemBehavior alloc]
                                        initWithItems:@[attributes]];
  dynamicItem.resistance = 10;
  [self.animator addBehavior:dynamicItem];

  [self updateDragLocation:p];
}

- (void)updateDragLocation:(CGPoint)p {
  self.behavior.anchorPoint = p;
}

- (void)stopDragging {
  // Move back to the original location (super)
  UICollectionViewLayoutAttributes *
  attributes = [super layoutAttributesForItemAtIndexPath:self.indexPath];
  [self updateDragLocation:attributes.center];
  self.indexPath = nil;
  self.behavior = nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  // Find all the attributes, and replace the one for our indexPath
  NSArray *existingAttributes = [super
                                 layoutAttributesForElementsInRect:rect];
  NSMutableArray *allAttributes = [NSMutableArray new];
  for (UICollectionViewLayoutAttributes *a in existingAttributes) {
    if (![a.indexPath isEqual:self.indexPath]) {
      [allAttributes addObject:a];
    }
  }

  [allAttributes addObjectsFromArray:[self.animator itemsInRect:rect]];
  return allAttributes;
}

@end
