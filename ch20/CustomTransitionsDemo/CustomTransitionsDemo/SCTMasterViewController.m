//
//  SCTMasterViewController.m
//  CustomTransitionsDemo
//
//  Created by Mugunth on 20/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTMasterViewController.h"

#import "SCTDetailViewController.h"

@interface SCTMasterViewController () {
    NSMutableArray *_objects;
}

@end

@implementation SCTMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *src = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *dest = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  CGRect f = src.view.frame;
  CGRect originalSourceRect = src.view.frame;
  f.origin.y = f.size.height;
  
  [UIView animateWithDuration:0.5 animations:^{
    src.view.frame = f;
    
  } completion:^(BOOL finished){
    src.view.alpha = 0;
    dest.view.frame = f;
    dest.view.alpha = 0.0f;
    [[src.view superview] addSubview:dest.view];
    [UIView animateWithDuration:0.5 animations:^{
      
      dest.view.frame = originalSourceRect;
      dest.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
      
      [dest.view removeFromSuperview];
      src.view.alpha = 1.0f;
      [transitionContext completeTransition:YES];
    }];
  }];
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  
  return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  return self;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

  NSDate *object = _objects[indexPath.row];
  cell.textLabel.text = [object description];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  SCTDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SCTDetailViewController"];
  
  detailViewController.detailItem = _objects[indexPath.row];
  detailViewController.transitioningDelegate = self;
  [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
