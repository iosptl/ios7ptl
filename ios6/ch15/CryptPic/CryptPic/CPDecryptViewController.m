//
//  CPSecondViewController.m
//  CryptPic
//

#import "CPDecryptViewController.h"
#import "CPCryptController.h"
#import <CommonCrypto/CommonCryptor.h>
#import "RNCryptManager.h"

@implementation CPDecryptViewController

- (void)refreshEnabled {
  self.decryptButton.enabled = ([self.password length] > 0);
}

- (void)viewDidLoad {
  [self refreshEnabled];
}

- (void)passwordViewController:(CPPasswordViewController *)vc didFinishWithPassword:(NSString *)password {
  self.password = password;
  [self refreshEnabled];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showPassword"]) {
    [[segue destinationViewController] setPassword:self.password];
    [[segue destinationViewController] setDelegate:self];
  }
}

- (IBAction)decrypt:(id)sender {
  NSError *error;
  NSData *data = [[CPCryptController sharedController] decryptDataWithPassword:self.password error:&error];
  if (! data) {
    if ([error code] == kRNCryptManagerErrorBadHMAC) {
      NSLog(@"Bad password");
      [self performSegueWithIdentifier:@"showPassword" sender:self];
    }
    else {
      NSAssert(NO, @"Couldn't decrypt: %@", error);
    }
  }
  self.imageView.image = [UIImage imageWithData:data];

}
- (void)viewDidUnload {
  [self setDecryptButton:nil];
  [super viewDidUnload];
}
@end
