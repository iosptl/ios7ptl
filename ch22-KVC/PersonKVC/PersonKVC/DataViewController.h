//
//  FirstViewController.h
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonManager;

@interface DataViewController : UIViewController 
@property (nonatomic, readwrite, strong) PersonManager *personManager;
@end
