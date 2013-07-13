//
//  MKAccordionButton.m
//  MKAccordion
//
//  Created by Mugunth on 24/7/12.
//  Copyright (c) 2012 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "MKAccordionButton.h"

@implementation MKAccordionButton

-(void) awakeFromNib {
  
  self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
  self.layer.borderWidth = 1.0f;
  [super awakeFromNib];
}
-(IBAction)buttonTapped:(id)sender {
  
  if(self.buttonTappedHandler)
    self.buttonTappedHandler();
}

@end
