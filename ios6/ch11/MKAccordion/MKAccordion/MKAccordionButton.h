//
//  MKAccordionButton.h
//  MKAccordion
//
//  Created by Mugunth on 24/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKAccordionButton : UIView
@property (nonatomic, weak) IBOutlet UIButton *mainButton;
@property (nonatomic, copy) void (^buttonTappedHandler)();
@end
