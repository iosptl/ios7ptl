//
//  NSCoder+RNMapKit.h
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSCoder (PTLMapKit)
- (void)ptl_encodeMKCoordinateRegion:(MKCoordinateRegion)region
                             forKey:(NSString *)key;
- (MKCoordinateRegion)ptl_decodeMKCoordinateRegionForKey:(NSString *)key;
@end
