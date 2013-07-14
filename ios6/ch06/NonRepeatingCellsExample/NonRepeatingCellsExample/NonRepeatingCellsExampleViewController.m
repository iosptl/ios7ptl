//
//  NonRepeatingCellsExampleViewController.m
//  NonRepeatingCellsExample
//
//  Created by Mugunth Kumar M on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NonRepeatingCellsExampleViewController.h"

@implementation NonRepeatingCellsExampleViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

-(CGFloat) tableView:(UITableView*) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            return self.headerCell.frame.size.height;
            break;
        case 1:
            return self.bodyCell.frame.size.height;
            break;
        case 2:
            return self.footerCell.frame.size.height;
            break;
            
        default:
            return 0;
            break;
    }
}

// table with with custom drawn cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            return self.headerCell;
            break;
        case 1:
            return self.bodyCell;
            break;
        case 2:
            return self.footerCell;
            break;
            
        default:
            return nil;
            break;
    }
}

@end
