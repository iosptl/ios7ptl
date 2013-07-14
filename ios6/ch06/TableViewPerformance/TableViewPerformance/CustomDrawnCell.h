//
//  CustomDrawnCell.h
//  TableViewPerformance
//
//  Created by Mugunth Kumar M on 25/8/11.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface CustomDrawnCell : ABTableViewCell  {
    
    NSString *_title;
    NSString *_subTitle;
    NSString *_timeTitle;
    UIImage *_thumbnail;
}

- (void)setTitle:(NSString*) title subTitle:(NSString*) subTitle time:(NSString*) time thumbnail:(UIImage *)aThumbnail;

@end
