//
//  CustomCell.m
//  TableViewPerformance
//
//  Created by Mugunth Kumar M on 23/8/11.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize timeTitleLabel = _timeTitleLabel;
@synthesize thumbnailImage = _thumbnailImage;

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

-(void) dealloc  {
        
    _titleLabel = nil;
    _subTitleLabel = nil;
    _timeTitleLabel = nil;
    _thumbnailImage = nil;
}
@end
