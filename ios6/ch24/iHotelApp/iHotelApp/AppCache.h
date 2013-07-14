//
//  AppCache.h
//  iHotelApp
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject

+(void) clearCache;
+(void) cacheMenuItems:(NSArray*) menuItems;
+(NSMutableArray*) getCachedMenuItems;
+(BOOL) isMenuItemsStale;

@end
