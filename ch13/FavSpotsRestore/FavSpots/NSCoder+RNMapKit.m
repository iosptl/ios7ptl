//
//  NSCoder+RNMapKit.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "NSCoder+RNMapKit.h"

@implementation NSCoder (RNMapKit)

- (void)RN_encodeMKCoordinateRegion:(MKCoordinateRegion)region
                             forKey:(NSString *)key {
  [self encodeObject:@[ @(region.center.latitude),
   @(region.center.longitude),
   @(region.span.latitudeDelta),
   @(region.span.longitudeDelta)]
              forKey:key];
}

- (MKCoordinateRegion)RN_decodeMKCoordinateRegionForKey:(NSString *)key {
  NSArray *array = [self decodeObjectForKey:key];
  MKCoordinateRegion region;
  region.center.latitude = [array[0] doubleValue];
  region.center.longitude = [array[1] doubleValue];
  region.span.latitudeDelta = [array[2] doubleValue];
  region.span.longitudeDelta = [array[3] doubleValue];
  return region;
}

@end
