//
//  RNSwizzle.m
//  MethodSwizzle

#import "RNSwizzle.h"
#import <objc/runtime.h>
@implementation NSObject (RNSwizzle)

+ (IMP)swizzleSelector:(SEL)origSelector 
               withIMP:(IMP)newIMP {
  Class class = [self class];
  Method origMethod = class_getInstanceMethod(class,
                                              origSelector);
  IMP origIMP = method_getImplementation(origMethod);
  
  if(!class_addMethod(self, origSelector, newIMP,
                      method_getTypeEncoding(origMethod)))
  {
    method_setImplementation(origMethod, newIMP);
  }
  
  return origIMP;
}
@end
