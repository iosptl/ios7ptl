//
//  NonRepeatingCellsExampleViewController.h
//  NonRepeatingCellsExample
//
//  Created by Mugunth Kumar M on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderCell.h"
#import "BodyCell.h"
#import "FooterCell.h"

@interface NonRepeatingCellsExampleViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) IBOutlet HeaderCell *headerCell;
@property (nonatomic, strong) IBOutlet BodyCell *bodyCell;
@property (nonatomic, strong) IBOutlet FooterCell *footerCell;
@end
