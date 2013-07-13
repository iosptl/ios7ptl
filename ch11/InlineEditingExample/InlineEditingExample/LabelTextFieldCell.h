//
//  LabelTextFieldCell.h
//  InlinteEditingExample
//
//  Created by Mugunth Kumar on 20-Jun-10.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelTextFieldCell : UITableViewCell 

@property (nonatomic, strong) IBOutlet UILabel *labelText;
@property (nonatomic, strong) IBOutlet UITextField *inputText;
@property (nonatomic, copy) void (^onTextEntered)(NSString *enteredText);

-(IBAction)textEditingDidEnd:(id)sender;
@end
