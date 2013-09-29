// PhotoViewController.h
// Based on Apple's PhotoScroller project

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (nonatomic) NSProgress *progress;

- (void)setImagePath:(NSString *)path size:(CGSize)size;

@end
