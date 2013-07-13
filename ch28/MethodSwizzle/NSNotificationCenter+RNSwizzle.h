//
//  NSNotification+RNSwizzle.h
//  MethodSwizzle
//
//  Created by Rob Napier on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (RNSwizzle)
+ (void)swizzleAddObserver;
@end
