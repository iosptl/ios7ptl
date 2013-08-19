//
//  AppDelegate.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "ModelController.h"

@implementation AppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [[ModelController sharedController] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [[ModelController sharedController] saveContext];
}

- (BOOL)application:(UIApplication *)application
shouldSaveApplicationState:(NSCoder *)coder {
  return YES;
}

- (BOOL)application:(UIApplication *)application
shouldRestoreApplicationState:(NSCoder *)coder {
  return YES;
}

@end
