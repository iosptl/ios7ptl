//
//  main.m
//  MethodSwizzle
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSNotificationCenter+RNSwizzle.h"

@interface Observer : NSObject
@end

@implementation Observer

- (void)somthingHappened:(NSNotification*)note {
  NSLog(@"Something happened");
}
@end

int main(int argc, char *argv[])
{
  int retVal = 0;
  @autoreleasepool {
    [NSNotificationCenter swizzleAddObserver];
    Observer *observer = [[Observer alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:@selector(somthingHappened:)
                                                 name:@"SomethingHappenedNotification"
                                               object:nil];
  }
  return retVal;
}
