//
//  RNSwizzle.h
//  MethodSwizzle

#import <Foundation/Foundation.h>

@interface NSObject (RNSwizzle)
+ (IMP)swizzleSelector:(SEL)origSelector
               withIMP:(IMP)newIMP;
@end
