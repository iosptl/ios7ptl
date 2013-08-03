//
//  AppDelegate.m
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "AppDelegate.h"
#import "PersonManager.h"
#import "RootViewController.h"

@interface AppDelegate ()
@property (nonatomic, readwrite, strong) PersonManager *modelController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.modelController = [PersonManager new];

  RootViewController *root = (id)self.window.rootViewController;
  root.personManager = self.modelController;
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
