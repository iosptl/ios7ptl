//
//  PictureCollection.h
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Picture;

@interface PictureCollection : NSObject
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithURL:(NSURL *)URL;
- (Picture *)pictureAtIndex:(NSUInteger)index;
- (void)reset;
@end
