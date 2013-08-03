//
//  ModelController.h
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@interface PersonManager : NSObject

- (NSUInteger)count;
- (Person *)personAtIndex:(NSUInteger)index;
@end
