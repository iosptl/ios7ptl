//
//  RESTError.h
//  iHotelApp
//
//  Created by Mugunth Kumar on 1-Jan-11.
//  Copyright 2010 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR" // rename this appropriately

@interface RESTError : NSError

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *errorCode;

- (NSString*) localizedOption;
-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;
@end
