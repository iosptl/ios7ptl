//
//  CPSecondViewController.h
//  CryptPic
//

#import <UIKit/UIKit.h>
#import "CPPasswordViewController.h"

@interface CPDecryptViewController : UIViewController <CPPasswordViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) IBOutlet UIButton *decryptButton;

- (IBAction)decrypt:(id)sender;

@end
