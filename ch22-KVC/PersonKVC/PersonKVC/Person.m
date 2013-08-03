//
//  Person.m
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithNameAndYear:(NSArray *)nameAndYear
{
  self = [super init];
  if (self) {
    _firstName = nameAndYear[0];
    _lastName = nameAndYear[1];
    _birthYear = [nameAndYear[2] integerValue];
  }
  return self;
}

- (NSInteger)age {
  NSInteger currentYear = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
  return currentYear - self.birthYear;
}

@end
