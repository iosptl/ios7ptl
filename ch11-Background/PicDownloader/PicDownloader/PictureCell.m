//
//  PictureCell.m
//  PicDownloader
//
//  Created by Rob Napier on 8/24/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PictureCell.h"
#import "Picture.h"

@interface PictureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PictureCell


- (void)setPicture:(Picture *)picture {
  if (_picture) {
    [_picture removeObserver:self forKeyPath:@"image"];
  }

  _picture = picture;

  if (_picture) {
    [_picture addObserver:self forKeyPath:@"image" options:0 context:NULL];
  }
  [self reloadImageView];
}

- (void)reloadImageView {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.imageView.image = self.picture.image;
  }
                 );
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self reloadImageView];
}

@end
