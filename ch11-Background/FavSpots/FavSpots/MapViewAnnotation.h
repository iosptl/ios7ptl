//
//  MapViewAnnotation.h
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Spot;

@interface MapViewAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly, weak) Spot *spot;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (MapViewAnnotation *)initWithSpot:(Spot *)spot;

@end
