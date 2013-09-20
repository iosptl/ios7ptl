//
//  DefaultBehavior.m
//  TearOff
//
//  Created by Rob Napier on 9/19/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "DefaultBehavior.h"

@implementation DefaultBehavior

- (instancetype)init {
  self = [super init];
  if (self) {
    UICollisionBehavior *collisionBehavior = [UICollisionBehavior new];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self addChildBehavior:collisionBehavior];

    UIGravityBehavior *gravityBehavior = [UIGravityBehavior new];
    [self addChildBehavior:gravityBehavior];
  }
  return self;
}

- (void)addItem:(id<UIDynamicItem>)item {
  for (id behavior in self.childBehaviors) {
    [behavior addItem:item];
  }
}

- (void)removeItem:(id<UIDynamicItem>)item {
  for (id behavior in self.childBehaviors) {
    [behavior removeItem:item];
  }
}

@end
