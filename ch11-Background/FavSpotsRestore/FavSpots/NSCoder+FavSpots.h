//
//  NSCoder+FavSpots.h
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCoder+RNMapKit.h"

@class Spot;

@interface NSCoder (FavSpots)
- (void)RN_encodeSpot:(Spot *)spot forKey:(NSString *)key;
- (Spot *)RN_decodeSpotForKey:(NSString *)key;
@end
