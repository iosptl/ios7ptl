//
//  iHotelAppAppDelegate.h
//  iHotelApp
//

#import <UIKit/UIKit.h>
#import "RESTfulEngine.h"
#define AppDelegate ((iHotelAppAppDelegate *)[UIApplication sharedApplication].delegate)

@class iHotelAppViewController;

@interface iHotelAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@property (nonatomic, strong) RESTfulEngine *engine;
@end
