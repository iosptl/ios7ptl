//
//  NSCoder+FavSpots.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "NSCoder+FavSpots.h"
#import "Spot.h"
#import "ModelController.h"

@implementation NSCoder (FavSpots)

- (void)RN_encodeSpot:(Spot *)spot forKey:(NSString *)key {
  NSManagedObjectID *spotID = spot.objectID;
  NSAssert(! [spotID isTemporaryID],
           @"Spot must not be temporary during state saving. %@",
           spot);
  
  [self encodeObject:[spotID URIRepresentation] forKey:key];
}

- (Spot *)RN_decodeSpotForKey:(NSString *)key {
  Spot *spot = nil;
  NSURL *spotURI = [self decodeObjectForKey:key];
  
  NSManagedObjectContext *
  context = [[ModelController sharedController]
             managedObjectContext];
  NSManagedObjectID *
  spotID = [[context persistentStoreCoordinator]
            managedObjectIDForURIRepresentation:spotURI];
  if (spotID) {
    spot = (Spot *)[context objectWithID:spotID];
  }
  
  return spot;
}

@end
