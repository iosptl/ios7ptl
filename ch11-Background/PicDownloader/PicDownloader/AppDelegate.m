//
//  AppDelegate.m
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "AppDelegate.h"
#import "PictureCollection.h"
#import "MainViewController.h"
#import "PTLDownloadManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  NSLog(@"%s", __PRETTY_FUNCTION__);

  PictureCollection *pictureCollection = [[PictureCollection alloc] initWithURL:[NSURL URLWithString:@"http://robnapier.net/ptl/PicDownloader"]];
  UINavigationController *nc = (id)self.window.rootViewController;
  MainViewController *mainVC = [nc viewControllers][0];
  mainVC.pictureCollection = pictureCollection;
  return YES;
}

- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {

  NSLog(@"%s", __PRETTY_FUNCTION__);
  
  PTLDownloadManager *downloadManager = [PTLDownloadManager downloadManagerWithIdentifier:identifier];
  downloadManager.backgroundSessionCompletionHandler = completionHandler;
}

@end
