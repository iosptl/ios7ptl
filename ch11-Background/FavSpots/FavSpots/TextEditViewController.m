//
//  TextEditViewController.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "TextEditViewController.h"
#import "Spot.h"
#import "NSCoder+FavSpots.h"

static NSString * const kSpotKey = @"kSpotKey";

@interface TextEditViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation TextEditViewController

- (void)saveChanges {
  self.spot.notes = self.textView.text;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];
  
  [coder RN_encodeSpot:self.spot forKey:kSpotKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  _spot = [coder RN_decodeSpotForKey:kSpotKey];
}

- (void)setSpot:(Spot *)spot {
  _spot = spot;
  [self configureView];
}

- (void)configureView {
  self.textView.text = self.spot.notes;
}

- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
  [self.textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(keyboardWasShown:)
             name:UIKeyboardDidShowNotification object:nil];
  [nc addObserver:self selector:@selector(willResignActive:)
             name:UIApplicationWillResignActiveNotification
           object:nil];
}

- (void)willResignActive:(NSNotification *)aNotification {
  [self saveChanges];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,
                                                kbSize.height, 0.0);
  self.textView.contentInset = contentInsets;
  self.textView.scrollIndicatorInsets = contentInsets;
}

- (void)viewWillDisappear:(BOOL)animated {
  [self saveChanges];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
