//
//  RESTfulEngine.m
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.

#import "RESTfulEngine.h"
#import "MenuItem.h"

@implementation RESTfulEngine

-(NSString*) accessToken
{
  if(!_accessToken)
  {
    _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenDefaultsKey];
  }
  
  return _accessToken;
}
-(void) setAccessToken:(NSString *) aAccessToken
{
  _accessToken = aAccessToken;
  
  // if you are going to have multiple accounts support,
  // it's advisable to store the access token as a serialized object
  // this code will break when a second RESTfulEngine object is instantiated and a new token is issued for him
  
  [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessTokenDefaultsKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) prepareHeaders:(MKNetworkOperation *)operation {
  
  // this inserts a header like ''Authorization = Token blahblah''
  if(self.accessToken)
    [operation setAuthorizationHeaderValue:self.accessToken forAuthType:@"Token"];
  
  [super prepareHeaders:operation];
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here
-(RESTfulOperation*) loginWithName:(NSString*) loginName
                          password:(NSString*) password
                       onSucceeded:(VoidBlock) succeededBlock
                           onError:(ErrorBlock) errorBlock
{
  RESTfulOperation *op = (RESTfulOperation*) [self operationWithPath:@"loginwaiter"];
  
  [op setUsername:loginName password:password basicAuth:YES];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    NSDictionary *responseDict = [completedOperation responseJSON];
    self.accessToken = [responseDict objectForKey:@"accessToken"];
    succeededBlock();
  }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    
    self.accessToken = nil;
    errorBlock(error);
    
  }];
	
	[self enqueueOperation:op];
  return op;
}

-(RESTfulOperation*) fetchMenuItemsOnSucceeded:(ArrayBlock) succeededBlock
                                       onError:(ErrorBlock) errorBlock
{
  RESTfulOperation *op = (RESTfulOperation*) [self operationWithPath:@"menuitem"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
    NSMutableArray *menuItemsJson = [responseDictionary objectForKey:@"menuitems"];
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    [menuItemsJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
      [menuItems addObject:[[MenuItem alloc] initWithDictionary:obj]];
    }];
    
    succeededBlock(menuItems);
    
  }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    errorBlock(error);
  }];
	
	[self enqueueOperation:op];
  return op;
}

-(RESTfulOperation*) fetchMenuItemsFromWrongLocationOnSucceeded:(ArrayBlock) succeededBlock
                                                        onError:(ErrorBlock) errorBlock
{
  RESTfulOperation *op = (RESTfulOperation*) [self operationWithPath:@"404"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    NSMutableArray *responseArray = [completedOperation responseJSON];
    NSMutableArray *menuItems = [NSMutableArray array];
    
    [responseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
      [menuItems addObject:[[MenuItem alloc] initWithDictionary:obj]];
    }];
    
    succeededBlock(menuItems);
    
  }   errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    errorBlock(error);
  }];
	
	[self enqueueOperation:op];
  return op;
}
@end
