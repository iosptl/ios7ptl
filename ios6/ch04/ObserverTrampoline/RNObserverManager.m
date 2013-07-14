//
//  RNObserverManager.m
//  ObserverTrampoline
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

#import "RNObserverManager.h"

@interface RNObserverManager ()
@property (nonatomic, readonly, strong) NSMutableSet *observers;
@property (nonatomic, readonly, strong) Protocol *protocol;
@end

@implementation RNObserverManager

- (id)initWithProtocol:(Protocol *)protocol
             observers:(NSSet *)observers {
	if ((self = [super init])) {
		_protocol = protocol;
		_observers = [NSMutableSet setWithSet:observers];
	}
	return self;
}

- (void)addObserver:(id)observer {
  NSAssert([observer conformsToProtocol:self.protocol], 
           @"Observer must conform to protocol.");
	[self.observers addObject:observer];
}

- (void)removeObserver:(id)observer {
	[self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	NSMethodSignature *
  result = [super methodSignatureForSelector:sel];
  if (result) {
   return result; 
  }
  
  // Look for a required method
	struct objc_method_description desc = 
             protocol_getMethodDescription(self.protocol,
                                           sel, YES, YES);
	if (desc.name == NULL) {
		// Couldn't find it. Maybe it's optional
		desc = protocol_getMethodDescription(self.protocol,
                                         sel, NO, YES);
	}
  
	if (desc.name == NULL) {
    // Couldn't find it. Raise NSInvalidArgumentException
		[self doesNotRecognizeSelector:sel];
		return nil;
  }
  
  return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	SEL selector = [invocation selector];
	for (id responder in self.observers) {
		if ([responder respondsToSelector:selector]) {
			[invocation setTarget:responder];
			[invocation invoke];
		}
	}
}

@end
