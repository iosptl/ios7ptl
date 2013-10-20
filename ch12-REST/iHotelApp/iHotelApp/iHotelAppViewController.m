//
//  iHotelAppViewController.m
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "iHotelAppViewController.h"
#import "RESTfulEngine.h"
#import "iHotelAppAppDelegate.h"
#import "iHotelAppViewController.h"
#import "iHotelAppMenuViewController.h"

@interface iHotelAppViewController (/*Private Methods*/)

@property (nonatomic) RESTfulOperation *menuRequest;

@end

@implementation iHotelAppViewController

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


-(void) viewDidDisappear:(BOOL)animated
{
  if(self.menuRequest)
    [self.menuRequest cancel];
  
	[super viewDidDisappear:animated];
}
#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"iHotel App Demo";
}

-(IBAction) loginButtonTapped:(id) sender
{
  [AppDelegate.engine loginWithName:@"mugunth"
                           password:@"abracadabra"
                        onSucceeded:^{
                          
                          [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"")
                                                      message:NSLocalizedString(@"Login successful", @"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                            otherButtonTitles: nil] show];
                          
                        } onError:^(NSError *engineError){
                          
                          [UIAlertView showWithError:engineError];
                        }];
}

-(IBAction) fetchMenuItems:(id) sender
{
  iHotelAppMenuViewController *controller = [[iHotelAppMenuViewController alloc] initWithNibName:nil
                                                                                          bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

-(IBAction) simulateRequestError:(id) sender
{
  // this request fails with a 404
  // we mock the method to return a error json from the error.json file
  [AppDelegate.engine fetchMenuItemsFromWrongLocationOnSucceeded:^(NSMutableArray *listOfModelBaseObjects) {
    
    DLog(@"%@", listOfModelBaseObjects);
    
  } onError:^(NSError *engineError) {
    [UIAlertView showWithError:engineError];
  }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end