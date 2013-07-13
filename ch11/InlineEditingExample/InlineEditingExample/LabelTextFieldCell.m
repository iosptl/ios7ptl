//
//  LabelTextFieldCell.m
//  InlinteEditingExample
//
//  Created by Mugunth Kumar on 20-Jun-10.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "LabelTextFieldCell.h"


@implementation LabelTextFieldCell
@synthesize labelText = _labelText;
@synthesize inputText = _inputText;
@synthesize onTextEntered = _onTextEntered;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

-(void) dealloc  {
    
    _labelText = nil;
    _inputText = nil;
}

-(IBAction)textEditingDidEnd:(id)sender  {
    
    self.onTextEntered(self.inputText.text);
}

@end
