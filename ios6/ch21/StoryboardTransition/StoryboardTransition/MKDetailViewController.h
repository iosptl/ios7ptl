//
//  MKDetailViewController.h
//  StoryboardTransition
//
//  Created by Mugunth Kumar on 24/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
