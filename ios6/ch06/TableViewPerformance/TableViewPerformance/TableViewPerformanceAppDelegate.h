//
//  TableViewPerformanceAppDelegate.h
//  TableViewPerformance
//
//  Created by Mugunth Kumar M on 23/8/11.
//

#import <UIKit/UIKit.h>

@class TableViewPerformanceViewController;

@interface TableViewPerformanceAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet TableViewPerformanceViewController *viewController;

@end
