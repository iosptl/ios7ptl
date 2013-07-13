//
//  NonRepeatingCellsExampleAppDelegate.h
//  NonRepeatingCellsExample
//
//  Created by Mugunth Kumar M on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NonRepeatingCellsExampleViewController;

@interface NonRepeatingCellsExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet NonRepeatingCellsExampleViewController *viewController;

@end
