//
//  InlineEditingExampleViewController.m
//  InlineEditingExample
//
//  Created by Mugunth Kumar M on 30/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InlineEditingExampleViewController.h"
#import "LabelTextFieldCell.h"

@implementation InlineEditingExampleViewController
@synthesize data = _data;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0 ; i < 10; i ++)
        [self.data insertObject:@"" atIndex:i];
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
    return [self.data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LabelTextFieldCell";
	
	LabelTextFieldCell *cell = (LabelTextFieldCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) {
		
    NSArray *nib = [[UINib nibWithNibName:@"LabelTextFieldCell" bundle:nil] instantiateWithOwner:self options:nil];
		cell = (LabelTextFieldCell*)[nib objectAtIndex:0];
	}
	
	// other initialization goes here
    cell.inputText.text = [self.data objectAtIndex:indexPath.row];
	__weak NSMutableArray *dataWeak = self.data;
    cell.onTextEntered = ^(NSString* enteredString) {
        [dataWeak setObject:enteredString atIndexedSubscript:indexPath.row];
    };

	return cell;
}

@end
