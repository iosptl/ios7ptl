//
//  UIDevice_MKAdditions.m
//  DeviceHelper
//
//  Created by Mugunth Kumar on 15-Aug-10.
//  Copyright 2010 Steinlogic. All rights reserved.

#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>

#import "UIDevice+MKAdditions.h"

@implementation UIDevice (MKAdditions)

- (BOOL) microphoneAvailable
{
	AVAudioSession *ptr = [AVAudioSession sharedInstance];
	return ptr.inputIsAvailable;
}

- (void) vibrateWithSound
{
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void) vibrateWithoutSound
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (BOOL) doesPhotoLibraryHavePictures
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) doesCameraRollHavePictures
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL) cameraAvailable
{
	return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) videoCameraAvailable
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
	
	if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]){
		
		return NO;
	}
	
	return YES;
}

- (BOOL) frontCameraAvailable
{
#ifdef __IPHONE_4_0
	return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
#else
	return NO;
#endif
	
}

- (BOOL) cameraFlashAvailable
{
#ifdef __IPHONE_4_0
	return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
#else
	return NO;
#endif
}

// later when Apple adds a camera flash to the front camera in iPhone 5 or 6 or whatever, this function can be uncommented :)
/*
- (BOOL) isCameraFlashAvailableForFrontCamera
{
#ifdef __IPHONE_5_0 or 6?!?
	return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
#else
	return NO;
#endif
}
*/

- (BOOL) canSendEmail
{
	return [MFMailComposeViewController canSendMail];
}

- (BOOL) canSendSMS
{
#ifdef __IPHONE_4_0
	return [MFMessageComposeViewController canSendText];
#else
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
#endif
}

- (BOOL) canMakePhoneCalls
{
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

- (BOOL) multitaskingCapable
{
	BOOL backgroundSupported = NO;
	if ([self respondsToSelector:@selector(multitaskingSupported)])
		backgroundSupported = self.multitaskingSupported;
	
	return backgroundSupported;
}

- (BOOL) compassAvailable
{
	BOOL compassAvailable = NO;
	
#ifdef __IPHONE_3_0
	compassAvailable = [CLLocationManager headingAvailable];
#else
	CLLocationManager *cl = [[CLLocationManager alloc] init];	
	compassAvailable = cl.headingAvailable;		
#endif
	
	return compassAvailable;

}

- (BOOL) gyroscopeAvailable
{
#ifdef __IPHONE_4_0
	CMMotionManager *motionManager = [[CMMotionManager alloc] init];
	BOOL gyroAvailable = motionManager.gyroAvailable;
	return gyroAvailable;
#else
	return NO;
#endif
	
}


- (BOOL) retinaDisplayCapable
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
		scale = screen.scale;
	
	if(scale == 2.0f) return YES;
	else return NO;
}

@end
