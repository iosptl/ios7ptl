//
//  PictureCell.h
//  PicDownloader
//
//  Created by Rob Napier on 8/24/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Picture;
@interface PictureCell : UICollectionViewCell
@property (nonatomic, readwrite, strong) Picture *picture;
@end
