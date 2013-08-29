//
//  PictureCollection.m
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PictureCollection.h"
#import "PTLDownloadManager.h"
#import "Picture.h"

@interface PictureCollection ()
@property (nonatomic, readwrite, copy) NSURL *URL;
@property (nonatomic, readwrite, strong) PTLDownloadManager *downloadManager;
@property (nonatomic, readwrite, strong) NSMutableArray *pictures;
@end

NSString * const kDownloadManagerIdentifier = @"com.iosptl.PicDownloader.PictureCollection";

@implementation PictureCollection

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (self) {
    _URL = URL;
    _downloadManager = [PTLDownloadManager downloadManagerWithIdentifier:kDownloadManagerIdentifier];
    [self updatePictures];
  }
  return self;
}

- (void)updatePictures {
  NSURL *metadata = [self.URL URLByAppendingPathComponent:@"pictures.json"];
  [self.downloadManager fetchDataAtURL:metadata
                     completionHandler:^(NSData *data, NSError *error) {
                              if (error) {
                                NSLog(@"Error downloading metadata: %@", error);
                                // TODO: Post notification or otherwise tell app about problem.
                              }
                              else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                  [self updatePicturesWithMetadata:data];
                                });
                              }
                            }];
}

- (NSURL *)documentURLForPath:(NSString *)path {
  static NSURL *documentDirectoryURL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    documentDirectoryURL = [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
  });

  return [documentDirectoryURL URLByAppendingPathComponent:path];
}

- (void)updatePicturesWithMetadata:(NSData *)metadata {
  NSLog(@"%s", __PRETTY_FUNCTION__);
  [self willChangeValueForKey:@"count"];
  NSError *error;
  NSString *JSONString = [[NSString alloc] initWithData:metadata encoding:NSUTF8StringEncoding];
  NSArray *pictureInfos = [NSJSONSerialization JSONObjectWithData:metadata options:0 error:&error];
  if (! pictureInfos) {
    NSLog(@"Error parsing metadata: %@\n%@", error, JSONString);
    // TODO: Post notification or otherwise tell app about problem.
    return;
  }

  self.pictures = [NSMutableArray new];
  for (NSDictionary *pictureInfo in pictureInfos) {
    NSString *path = pictureInfo[@"path"];
    if (!path) {
      NSLog(@"Missing path: %@", JSONString);
    }
    else {
      NSURL *URL = [self.URL URLByAppendingPathComponent:path];
      Picture *picture = [[Picture alloc] initWithRemoteURL:URL downloadManager:self.downloadManager];
      [self.pictures addObject:picture];
    }
  }
  [self didChangeValueForKey:@"count"];
}

- (NSUInteger)count {
  return self.pictures.count;
}

- (Picture *)pictureAtIndex:(NSUInteger)index {
  return self.pictures[index];
}

- (void)reset {
  NSFileManager *fm = [NSFileManager defaultManager];
  for (Picture *picture in self.pictures) {
    [fm removeItemAtURL:picture.localURL error:NULL];
  }
}

@end
