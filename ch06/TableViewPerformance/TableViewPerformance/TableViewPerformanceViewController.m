//
//  TableViewPerformanceViewController.m
//  TableViewPerformance
//
//  Created by Mugunth Kumar M on 23/8/11.
//

#import "TableViewPerformanceViewController.h"
#import "CustomDrawnCell.h"
#import "CustomCell.h"

@implementation TableViewPerformanceViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    return 1000;
}

/*
// table with with built in cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"ios5"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
*/

// table with normal XIB based cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
	
	CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) {
		
    
		NSArray *nib = [[UINib nibWithNibName:@"CustomCell" bundle:nil] instantiateWithOwner:self options:nil];
		cell = (CustomCell*)[nib objectAtIndex:0];
	}
	
	// other initialization goes here
    cell.titleLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    cell.timeTitleLabel.text = @"yesterday";
    cell.thumbnailImage.image = [UIImage imageNamed:@"iOS6"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}


/*
// table with with custom drawn cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomDrawnCell";
	
	CustomDrawnCell *cell = (CustomDrawnCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) 
	{		
		cell = [[CustomDrawnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];	
	}
	
    [cell setTitle:[NSString stringWithFormat:@"Row %d", indexPath.row] 
          subTitle:[NSString stringWithFormat:@"Row %d", indexPath.row] 
              time:@"yesterday"
         thumbnail:[UIImage imageNamed:@"ios5"]];
    
	// other initialization goes here
	return cell;
}*/

@end
