//
//  RNObserverManager.h
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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/*
 Trampoline to simplify sending messages to responding targets. In
 order to call -someClass:didSomethingToObject: (from the 
 <SomeClass> protocol) on all your observers who implement it:
 
 id observerManager =
   [[RNObserverManager alloc]
     initWithProtocol:@protocol(SomeClassListener)
            observers:observers];
 [observerManager someClass:self didSomethingToObject:someObject];
 
 The message *must* be part of the given protocol. It is safe to
 reuse this trampoline. Generally if you do this, you will want to
 store it as an "id" so that you can pass arbitrary messages to it.
*/

@interface RNObserverManager : NSObject

- (id)initWithProtocol:(Protocol *)protocol
             observers:(NSSet *)observers;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
