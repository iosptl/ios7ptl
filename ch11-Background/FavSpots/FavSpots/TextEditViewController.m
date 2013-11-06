//  Copyright (c) 2012 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
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
