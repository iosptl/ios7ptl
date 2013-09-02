//
//  UIBezierPath+MBH.h
//  MrBlockhead
//
//  Created by Rob Napier on 9/2/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (MBH)

+ (NSArray *)mbh_assortedBezierPathsInRect:(CGRect)rect withSelectors:(SEL)firstSelector, ... NS_REQUIRES_NIL_TERMINATION;
+ (UIBezierPath *)mbh_bezierPathWithSelector:(SEL)selector inRect:(CGRect)rect lineWidth:(CGFloat)lineWidth;
+ (UIBezierPath *)mbh_bezierPathWithTriangleInRect:(CGRect)rect;
@end

