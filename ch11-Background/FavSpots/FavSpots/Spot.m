//
//  Location.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "Spot.h"
#import "ModelController.h"

@implementation Spot

@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic notes;

+ (Spot *)insertNewSpotWithCoordinate:(CLLocationCoordinate2D)coordinate inManagedObjectContext:(NSManagedObjectContext *)context
{
  Spot *spot = [NSEntityDescription insertNewObjectForEntityForName:@"Spot" inManagedObjectContext:context];
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  df.dateStyle = NSDateFormatterShortStyle;
  df.timeStyle = NSDateFormatterShortStyle;
  spot.name = [NSString stringWithFormat:@"New Spot (%@)", [df stringFromDate:[NSDate date]]];
  spot.latitude = coordinate.latitude;
  spot.longitude = coordinate.longitude;
  return spot;
}

@end
