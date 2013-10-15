//
//  DraggableView.h
//  TearOff
//
//  Created by Rob Napier on 9/14/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView <NSCopying>
- (instancetype)initWithFrame:(CGRect)frame
                     animator:(UIDynamicAnimator *)animator;
@end
