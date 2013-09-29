//
//  MassiveSorter.h
//  MassiveSort
//
//  Created by Rob Napier on 9/29/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MassiveSorterHandler)(CGFloat progress, BOOL done);

@interface MassiveSorter : NSObject
- (void)generateRandomFileAtPath:(NSString *)path count:(long)count handler:(MassiveSorterHandler)handler;
- (void)sortFileAtPath:(NSString *)path;
- (void)printNumbersAtPath:(NSString *)path;
@end
