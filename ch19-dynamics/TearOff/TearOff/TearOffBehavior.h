//
//  TearOffBehavior.h
//  TearOff
//
//  Created by Rob Napier on 9/18/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggableView;

typedef void(^TearOffHandler)(DraggableView *tornView,
                              DraggableView *newPinView);

@interface TearOffBehavior : UIDynamicBehavior
@property(nonatomic) BOOL active;

- (instancetype) initWithDraggableView:(DraggableView *)view
                                anchor:(CGPoint)anchor
                               handler:(TearOffHandler)handler;
@end
