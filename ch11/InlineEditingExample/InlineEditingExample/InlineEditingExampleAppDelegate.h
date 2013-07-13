//
//  InlineEditingExampleAppDelegate.h
//  InlineEditingExample
//
//  Created by Mugunth Kumar M on 30/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InlineEditingExampleViewController;

@interface InlineEditingExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet InlineEditingExampleViewController *viewController;

@end
