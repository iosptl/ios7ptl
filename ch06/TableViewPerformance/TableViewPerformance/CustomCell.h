//
//  CustomCell.h
//  TableViewPerformance
//
//  Created by Mugunth Kumar M on 23/8/11.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImage;
@end
