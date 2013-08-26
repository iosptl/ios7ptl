//
//  ViewController.h
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureCollection;

@interface MainViewController : UICollectionViewController
@property (nonatomic, readwrite, strong) PictureCollection *pictureCollection;
@end
