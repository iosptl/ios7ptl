//
//  iHotelAppAppDelegate.h
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTfulEngine.h"
#define AppDelegate ((iHotelAppAppDelegate *)[UIApplication sharedApplication].delegate)

@class iHotelAppViewController;

@interface iHotelAppAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UINavigationController *navController;

@property (nonatomic, strong) RESTfulEngine *engine;
@end

