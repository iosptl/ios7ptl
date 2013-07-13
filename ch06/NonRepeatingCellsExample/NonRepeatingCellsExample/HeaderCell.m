//
//  HeaderCell.m
//  NonRepeatingCellsExample
//
//  Created by Mugunth Kumar M on 26/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
