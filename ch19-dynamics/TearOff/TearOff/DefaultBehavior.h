//
//  DefaultBehavior.h
//  TearOff
//
//  Created by Rob Napier on 9/19/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultBehavior : UIDynamicBehavior
- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;
@end
