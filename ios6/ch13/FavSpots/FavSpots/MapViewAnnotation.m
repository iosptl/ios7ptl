//
//  MapViewAnnotation.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "MapViewAnnotation.h"
#import "Spot.h"

@implementation MapViewAnnotation

//+ (NSSet *)keyPathsForValuesAffectingCoordinate {
//  return [NSSet setWithArray:@[ @"spot.latitude", @"spot.longitude" ]];
//}

- (MapViewAnnotation *)initWithSpot:(Spot *)spot
{
  self = [super init];
  if (self) {
    _spot = spot;
  }
  return self;
}

- (CLLocationCoordinate2D)coordinate {
  return CLLocationCoordinate2DMake(self.spot.latitude, self.spot.longitude);
}

@end
