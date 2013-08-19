//
//  Model.h
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelController : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

+ (ModelController *)sharedController;

@end
