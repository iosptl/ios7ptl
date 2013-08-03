//
//  SecondViewController.h
//  PersonKVC
//
//  Created by Rob Napier on 8/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonManager;

@interface StatsViewController : UIViewController
@property (nonatomic, readwrite, strong) IBOutlet PersonManager *personManager;
@end
