//
//  ViewController.m
//  ObserverTrampoline
//
//  Created by Rob Napier on 9/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RNObserverManager.h"

@protocol MyProtocol <NSObject>

- (void)doSomething;

@end

@interface MyClass : NSObject <MyProtocol>
@end

@implementation MyClass

- (void)doSomething {
  NSLog(@"doSomething :%@", self);
}

@end

@implementation ViewController
@synthesize observerManager=trampoline_;

- (void)viewDidLoad {
  [super viewDidLoad];
  NSSet *observers = [NSSet setWithObjects:[MyClass new], 
                      [MyClass new], nil];

  self.observerManager = [[RNObserverManager alloc] 
                          initWithProtocol:@protocol(MyProtocol) 
                          observers:observers];
  
  [self.observerManager doSomething];
}

@end
