//
//  ModelController.m
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PersonManager.h"
@import CoreData;

#import "Person.h"

@interface PersonManager ()
@property (nonatomic, readonly, strong) NSMutableArray *persons;
@end

@implementation PersonManager

- (instancetype)init {
  self = [super init];

  if (self) {
    NSArray *data = @[ @[ @"Jimi", @"Hendrix", @(1942) ],
                       @[ @"George", @"Harrison", @(1943) ],
                       @[ @"Carols", @"Santana", @(1947) ],
                       @[ @"Jimmy", @"Page", @(1944) ],
                       @[ @"B.B.", @"King", @(1925) ],
                       @[ @"Eric", @"Clapton", @(1945) ],
                       @[ @"Keith", @"Richards", @(1943) ],
                       @[ @"Angus", @"Young", @(1955) ],
                       @[ @"Eddie", @"Van Halen", @(1955) ],
                       @[ @"David", @"Gilmour", @(1946) ],
                       @[ @"Nikki", @"Sixx", @(1958) ],
                       @[ @"Chuck", @"Berry", @(1926) ],
                       @[ @"Brian", @"May", @(1947) ],
                       @[ @"Pete", @"Townshend", @(1945) ],
                       @[ @"Steve", @"Vai",  @(1960) ],
                       ];

    _persons = [NSMutableArray new];
    for (NSArray *nameAndYear in data) {
      [_persons addObject:[[Person alloc] initWithNameAndYear:nameAndYear]];
    }

  }
  return self;
}


@end
