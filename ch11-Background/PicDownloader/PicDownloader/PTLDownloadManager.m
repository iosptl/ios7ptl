//
//  PTLDownloadManager.m
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "PTLDownloadManager.h"

NSString * const PTLDownloadManagerDidDownloadFileNotification = @"PTLDownloadManagerDidDownloadFileNotification";
NSString * const PTLDownloadManagerSourceURLKey = @"PTLDownloadManagerSourceURLKey";
NSString * const PTLDownloadManagerDestinationURLKey = @"PTLDownloadManagerDestinationURLKey";

@interface PTLDownloadManager () <NSURLSessionDelegate>
@property (nonatomic, readwrite, strong) NSURLSession *foregroundSession;
@property (nonatomic, readwrite, strong) NSURLSession *backgroundSession;
@end

@implementation PTLDownloadManager

- (instancetype)init {
  NSAssert(NO, @"Use +downloadManagerWithIdentifer:");
  return nil;
}

+ (instancetype)downloadManagerWithIdentifier:(NSString *)identifier {
  static NSMutableDictionary *downloadManagers;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    downloadManagers = [NSMutableDictionary new];
  });

  PTLDownloadManager *downloadManager = downloadManagers[identifier];
  if (!downloadManager) {
    downloadManager = [[self alloc] initWithIdentifier:identifier];
    downloadManagers[identifier] = downloadManager;
  }
  return downloadManager;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
  self = [super init];
  if (self) {
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
		_backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    _foregroundSession = [NSURLSession sharedSession];
  }
  return self;
}

- (void)fetchDataAtURL:(NSURL *)URL
     completionHandler:(void (^)(NSData *, NSError *))handler {

  NSLog(@"%s:%@", __PRETTY_FUNCTION__, URL);
  NSURLSessionDataTask *task = [self.foregroundSession dataTaskWithURL:URL
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       handler(data, error);
  }];
  [task resume];
  NSLog(@"exit:%s", __PRETTY_FUNCTION__);
}

- (void)downloadURLToDocuments:(NSURL *)URL {
  NSLog(@"%s:%@", __PRETTY_FUNCTION__, URL);
  NSURLSessionDownloadTask *task = [self.backgroundSession downloadTaskWithURL:URL];
  [task resume];
}

- (NSURL *)localURLForRemoteURL:(NSURL *)remoteURL {
  static NSURL *documentDirectoryURL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES) firstObject];
    documentDirectoryURL = [NSURL fileURLWithPath:docPath];
  });

  NSString *filename = [remoteURL lastPathComponent];
  return [documentDirectoryURL URLByAppendingPathComponent:filename];
}

- (void)moveFileFromLocation:(NSURL *)location forDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
  NSURL *sourceURL = [[downloadTask originalRequest] URL];
  NSURL *destURL = [self localURLForRemoteURL:sourceURL];

  NSError *error;
  NSFileManager *fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:[destURL path]]) {
    [fm removeItemAtURL:destURL error:NULL];
  }

  if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:destURL error:&error]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:PTLDownloadManagerDidDownloadFileNotification
                                                        object:self
                                                      userInfo:@{PTLDownloadManagerSourceURLKey: sourceURL,
                                                                 PTLDownloadManagerDestinationURLKey: destURL}];
  }
  else {
    NSLog(@"Could not move file:%@", error);
  }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {

  NSLog(@"%s:%@", __PRETTY_FUNCTION__, location);

  [self moveFileFromLocation:(NSURL *)location forDownloadTask:downloadTask];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
  NSLog(@"%s", __PRETTY_FUNCTION__);
  [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks,
                                                          NSArray *uploadTasks,
                                                          NSArray *downloadTasks) {
		NSUInteger count = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
		if (count == 0) {
			if (self.backgroundSessionCompletionHandler) {
				void (^completionHandler)() = self.backgroundSessionCompletionHandler;
				self.backgroundSessionCompletionHandler = nil;
				completionHandler();
			}
		}
	}];
}

@end
