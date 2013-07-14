//
//  CPPasswordViewController.h
//  CryptPic
//

#import <UIKit/UIKit.h>

@class CPPasswordViewController;

@protocol CPPasswordViewControllerDelegate <NSObject>
- (void)passwordViewController:(CPPasswordViewController *)vc didFinishWithPassword:(NSString *)password;
@end

@interface CPPasswordViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (copy, nonatomic) NSString *password;
@property (weak, nonatomic) id<CPPasswordViewControllerDelegate> delegate;
@end
