//
//  SCTViewController.m
//  BlurDemo
//
//  Created by Mugunth on 19/8/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTViewController.h"

#import "UIImage+ImageEffects.h"

@interface SCTViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) CALayer *layer;
@end

@implementation SCTViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)buttonAction:(id)sender {
  
  self.layer = [CALayer layer];
  self.layer.frame = CGRectMake(80, 100, 160, 160);
  [self.view.layer addSublayer:self.layer];

  float scale = [UIScreen mainScreen].scale;
  UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, scale);
  [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
  __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,
                                                     CGRectMake(self.layer.frame.origin.x * scale,
                                                                self.layer.frame.origin.y * scale,
                                                                self.layer.frame.size.width * scale,
                                                                self.layer.frame.size.height * scale));
  image = [UIImage imageWithCGImage:imageRef];
  image = [image applyBlurWithRadius:50.0f
                           tintColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.1]
               saturationDeltaFactor:2.0f
                           maskImage:nil];

  self.layer.contents = (__bridge id)(image.CGImage);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
