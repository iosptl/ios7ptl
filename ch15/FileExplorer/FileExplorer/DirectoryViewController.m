//
//  DirectoryViewController.m
//  FileExplorer
//
//  Created by Rob Napier on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectoryViewController.h"

@implementation DirectoryViewController

- (void)setPath:(NSString *)path {
  _path = path;
  [self setTitle:[path lastPathComponent]];
}

- (void)loadContents {
  if (self.contents == nil) {
    if (self.path == nil) {
      self.path = @"/";
    }
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    self.contents = [fileManager contentsOfDirectoryAtPath:self.path
                                                    error:&error];
    if (error) {
      NSLog(@"Error: %@", error);
    }
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  [self loadContents];
  return self.contents.count;
}

- (BOOL)isDirectoryAtEntryPath:(NSString *)entryPath {
  BOOL isDirectory;
  NSFileManager *fm = [[NSFileManager alloc] init];
  NSString *fullPath = [self.path stringByAppendingPathComponent:entryPath];
  [fm fileExistsAtPath:fullPath isDirectory:&isDirectory];
  return isDirectory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self loadContents];
  static NSString *cellIdentifier = @"DirectoryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
  }
  
  NSString *entryPath = [self.contents objectAtIndex:indexPath.row];
  NSFileManager *fm = [[NSFileManager alloc] init];
  NSError *error;
  NSDictionary *attributes = [fm attributesOfItemAtPath:[self.path stringByAppendingPathComponent:entryPath] error:&error];
  if (!attributes) {
    NSLog(@"Couldn't get attributes for %@: %@", entryPath, error);
  }
  NSLog(@"%@=%@", entryPath, attributes);
  cell.textLabel.text = [NSString stringWithFormat:@"%03o  %@(%@)  %@", 
                         [[attributes objectForKey:NSFilePosixPermissions] unsignedIntValue],
                         [attributes objectForKey:NSFileOwnerAccountName], 
                         [attributes objectForKey:NSFileOwnerAccountID],
                         [entryPath lastPathComponent]];

  if ([self isDirectoryAtEntryPath:entryPath]) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *entryPath = [self.contents objectAtIndex:indexPath.row];
  return [self isDirectoryAtEntryPath:entryPath] ? indexPath : nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSString *fullPath = [self.path stringByAppendingPathComponent:
                        [self.contents objectAtIndex:
                         [self.tableView indexPathForSelectedRow].row]];
  [segue.destinationViewController setPath:fullPath];
}

@end
