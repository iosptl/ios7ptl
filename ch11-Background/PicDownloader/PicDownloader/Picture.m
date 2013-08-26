//
//  Picture.m
//  PicDownloader
//
//  Created by Rob Napier on 8/24/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "Picture.h"
#import "PTLDownloadManager.h"

@interface Picture ()
@property (nonatomic, readwrite, strong) UIImage *image;
@end
@implementation Picture

- (instancetype)initWithRemoteURL:(NSURL *)URL downloadManager:(PTLDownloadManager *)downloadManager {
  self = [super init];
  if (self) {
    _downloadManager = downloadManager;
    _remoteURL = URL;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[downloadManager localURLForRemoteURL:URL] path]]) {
      [_downloadManager downloadURLToDocuments:_remoteURL];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(downloadManagerDidDownloadFile:)
                                                   name:PTLDownloadManagerDidDownloadFileNotification
                                                 object:nil];
    }
    [self reloadImage];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)downloadManagerDidDownloadFile:(NSNotification *)note {
  NSURL *URL = [note userInfo][PTLDownloadManagerSourceURLKey];
  if ([URL isEqual:self.remoteURL]) {
    [self reloadImage];
  }
}

- (void)reloadImage {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = [UIImage imageWithContentsOfFile:self.localURL.path];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.image = image;
    });
  });
}

- (NSURL *)localURL {
  return [self.downloadManager localURLForRemoteURL:self.remoteURL];
}

@end
