//
//  Person.m
//  Person
//
//  Copyright (c) 2012 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person ()
@property (strong) NSMutableDictionary *properties;
@end

@implementation Person
@dynamic givenName, surname;

- (id)init {
  if ((self = [super init])) {
    _properties = [[NSMutableDictionary alloc] init];
  }
  return self;
}

static id propertyIMP(id self, SEL _cmd) {
  return [[self properties] valueForKey:
          NSStringFromSelector(_cmd)];
}

static void setPropertyIMP(id self, SEL _cmd, id aValue) {
  id value = [aValue copy];
  
  NSMutableString *key =
  [NSStringFromSelector(_cmd) mutableCopy];
  
  // Delete "set" and ":" and lowercase first letter
  [key deleteCharactersInRange:NSMakeRange(0, 3)];
  [key deleteCharactersInRange:
   NSMakeRange([key length] - 1, 1)];
  NSString *firstChar = [key substringToIndex:1];
  [key replaceCharactersInRange:NSMakeRange(0, 1)
                     withString:[firstChar lowercaseString]];
  
  [[self properties] setValue:value forKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
  if ([NSStringFromSelector(aSEL) hasPrefix:@"set"]) {
    class_addMethod([self class], aSEL,
                    (IMP)setPropertyIMP, "v@:@");
  }
  else {
    class_addMethod([self class], aSEL,
                    (IMP)propertyIMP, "@@:");
  }
  return YES;
}
@end
