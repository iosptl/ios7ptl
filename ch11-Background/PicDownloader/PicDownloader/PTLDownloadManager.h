//
//  PTLDownloadManager.h
//  PicDownloader
//
//  Created by Rob Napier on 8/23/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PTLDownloadManagerDidDownloadFileNotification;
extern NSString * const PTLDownloadManagerSourceURLKey;
extern NSString * const PTLDownloadManagerDestinationURLKey;

@protocol PTLDownloadManagerDelegate;

@interface PTLDownloadManager : NSObject
@property (copy) void (^backgroundSessionCompletionHandler)();

+ (instancetype)downloadManagerWithIdentifier:(NSString *)identifier;
- (void)fetchDataAtURL:(NSURL *)URL
     completionHandler:(void (^)(NSData *, NSError *))completion;

- (void)downloadURLToDocuments:(NSURL *)sourceURL;
- (NSURL *)localURLForRemoteURL:(NSURL *)remoteURL;

@end

@protocol PTLDownloadManagerDelegate <NSObject>

- (void)downloadManager:(PTLDownloadManager *)manager
didFinishDownloadFromURL:(NSURL *)sourceURL
                  toURL:(NSURL *)destURL;

@end