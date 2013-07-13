//
//  CPPasswordViewController.m
//  CryptPic
//

#import "CPPasswordViewController.h"

@implementation CPPasswordViewController

- (void)viewDidAppear:(BOOL)animated {
  [self.passwordTextField becomeFirstResponder];
  self.passwordTextField.text = self.password;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    self.password = self.passwordTextField.text;
    [self.delegate passwordViewController:self didFinishWithPassword:self.password];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return NO;
  }
  return YES;
}

@end
