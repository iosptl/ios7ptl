//
//  SCTDetailViewController.h
//  CustomTransitionsDemo
//
//  Created by Mugunth on 20/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
