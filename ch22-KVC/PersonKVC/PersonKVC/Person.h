//
//  Person.h
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSInteger birthYear;

- (NSInteger)age;

- (id)initWithNameAndYear:(NSArray *)nameAndYear;

@end
