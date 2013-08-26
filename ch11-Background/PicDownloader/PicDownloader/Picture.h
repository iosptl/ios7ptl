//
//  Picture.h
//  PicDownloader
//
//  Created by Rob Napier on 8/24/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTLDownloadManager;
@interface Picture : NSObject

@property (nonatomic, readonly) NSURL *remoteURL;
@property (nonatomic, readonly) NSURL *localURL;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) PTLDownloadManager *downloadManager;

- (instancetype)initWithRemoteURL:(NSURL *)URL downloadManager:(PTLDownloadManager *)downloadManager;;

@end
