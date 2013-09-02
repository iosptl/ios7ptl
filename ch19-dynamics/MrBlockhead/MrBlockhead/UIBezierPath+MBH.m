//
//  UIBezierPath+MBH.m
//  MrBlockhead
//
//  Created by Rob Napier on 9/2/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "UIBezierPath+MBH.h"

@implementation UIBezierPath (MBH)

+ (NSArray *)mbh_assortedBezierPathsInRect:(CGRect)rect withSelectors:(SEL)firstSelector, ... {
  NSMutableArray *paths = [NSMutableArray new];

  va_list selectors;
  va_start(selectors, firstSelector);
  for (SEL selector = firstSelector; selector != NULL; selector = va_arg(selectors, SEL) ) {
    [paths addObjectsFromArray:@[
                                 [self mbh_bezierPathWithSelector:selector inRect:rect lineWidth:1],
                                 [self mbh_bezierPathWithSelector:selector inRect:rect lineWidth:10],
                                 [self mbh_bezierPathWithSelector:selector inRect:rect lineWidth:0],
                                 ]];
  }
  va_end(selectors);

  return paths;
}

+ (UIBezierPath *)mbh_bezierPathWithTriangleInRect:(CGRect)rect {
  UIBezierPath *path = [UIBezierPath new];

  CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGPoint point2 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));

  [path moveToPoint:point1];
  [path addLineToPoint:point2];
  [path addLineToPoint:point3];
  [path closePath];
  return path;
}

+ (UIBezierPath *)mbh_bezierPathWithSelector:(SEL)selector inRect:(CGRect)rect lineWidth:(CGFloat)lineWidth {
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIBezierPath methodSignatureForSelector:selector]];
  [invocation setSelector:selector];
  [invocation setTarget:[UIBezierPath class]];
  [invocation setArgument:&rect atIndex:2];
  [invocation invoke];
  void *result;
  [invocation getReturnValue:&result];
  UIBezierPath *path = (__bridge id)result;

  if (lineWidth > 0) {
    CGRect insetRect = CGRectInset(rect, lineWidth, lineWidth);
    [invocation setArgument:&insetRect atIndex:2];
    [invocation invoke];
    [invocation getReturnValue:&result];
    [path appendPath:(__bridge id)result];
  }

  return path;
}


@end

