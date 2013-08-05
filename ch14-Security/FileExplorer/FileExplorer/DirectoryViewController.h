//
//  DirectoryViewController.h
//  FileExplorer
//
//  Created by Rob Napier on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryViewController : UITableViewController

@property (nonatomic, readwrite, strong) NSString *path;
@property (nonatomic, readwrite, strong) NSArray *contents;
@end
