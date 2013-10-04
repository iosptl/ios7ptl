//
//  ViewController.m
//  DispatchDownload
//
//  Created by Rob Napier on 10/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>


@implementation ViewController

- (dispatch_fd_t)connectToHostName:(NSString *)hostName port:(int)port {
  int s;
  struct sockaddr_in sa;
  struct hostent *he;

  if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
    NSAssert(NO, @"socket failed:%d", errno);
  }

  bzero(&sa, sizeof sa);

  sa.sin_family = AF_INET;
  sa.sin_port = htons(port);

  if ((he = gethostbyname([hostName UTF8String])) == NULL) {
    NSAssert(NO, @"gethostbyname failure:%d", errno);
  }

  bcopy(he->h_addr_list[0], &sa.sin_addr, he->h_length);

  if (connect(s, (struct sockaddr *)&sa, sizeof sa) < 0) {
    close(s);
    NSAssert(NO, @"connect failed:%d", errno);
  }

  return s;
}

- (NSString *)outputFilePathForPath:(NSString *)path {
  return [[NSTemporaryDirectory() stringByAppendingPathComponent:[path lastPathComponent]] stringByAppendingPathExtension:@"out"];
}

- (void)writeToChannel:(dispatch_io_t)channel
                  data:(dispatch_data_t)writeData
                 queue:(dispatch_queue_t)queue {
  dispatch_io_write(channel, 0, writeData, queue,
                    ^(bool done, dispatch_data_t remainingData, int error) {
                      NSAssert(!error, @"File write error:%d", error);
                      size_t unwrittenDataLength = 0;
                      if (remainingData) {
                        unwrittenDataLength = dispatch_data_get_size(remainingData);
                      }
                      NSLog(@"Wrote %zu bytes",
                            dispatch_data_get_size(writeData) - unwrittenDataLength);
                    });

}

- (void)readFromChannel:(dispatch_io_t)readChannel
         writeToChannel:(dispatch_io_t)writeChannel
                  queue:(dispatch_queue_t)queue {
  dispatch_io_read(readChannel, 0, SIZE_MAX, queue,
                   ^(bool serverReadDone,
                     dispatch_data_t serverReadData,
                     int serverReadError) {

                     NSAssert(!serverReadError,
                              @"Server read error:%d", serverReadError);
                     if (serverReadDone) {
                       NSLog(@"Done Downloading");
                       dispatch_io_close(writeChannel, 0);
                       dispatch_io_close(readChannel, 0);
                     }
                     else {
                       [self writeToChannel:writeChannel
                                       data:serverReadData
                                      queue:queue];
                     }
                   });
}

- (dispatch_data_t)requestDataForHostName:(NSString *)hostName
                                     path:(NSString *)path {
  NSString *
  getString = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %@\r\n\r\n",
               path, hostName];
  NSLog(@"Request:\n%@", getString);

  NSData *getData = [getString dataUsingEncoding:NSUTF8StringEncoding];
  return dispatch_data_create(getData.bytes,
                              getData.length,
                              NULL,
                              DISPATCH_DATA_DESTRUCTOR_DEFAULT);
}

- (void)HTTPDownloadContentsFromHostName:(NSString *)hostName
                                    port:(int)port
                                    path:(NSString *)path {

  dispatch_queue_t queue = dispatch_get_main_queue();

  dispatch_fd_t socket = [self connectToHostName:hostName port:port];

  dispatch_io_t
  serverChannel = dispatch_io_create(DISPATCH_IO_STREAM, socket, queue,
                                     ^(int error) {
                                       NSAssert(!error,
                                                @"Failed socket:%d", error);
                                       NSLog(@"Closing connection");
                                       close(socket);
                                     });

  dispatch_data_t requestData = [self requestDataForHostName:hostName path:path];

  NSString *writePath = [self outputFilePathForPath:path];
  NSLog(@"Writing to %@", writePath);

  dispatch_io_t
  fileChannel = dispatch_io_create_with_path(DISPATCH_IO_STREAM,
                                             [writePath UTF8String],
                                             O_WRONLY|O_CREAT|O_TRUNC,
                                             S_IRWXU,
                                             queue,
                                             nil);

  dispatch_io_write(serverChannel, 0, requestData, queue,
                    ^(bool serverWriteDone,
                      dispatch_data_t serverWriteData,
                      int serverWriteError) {

                      NSAssert(!serverWriteError,
                               @"Server write error:%d", serverWriteError);
                      if (serverWriteDone) {
                        [self readFromChannel:serverChannel
                               writeToChannel:fileChannel
                                        queue:queue];
                      }
                    });
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self HTTPDownloadContentsFromHostName:@"upload.wikimedia.org"
                                    port:80
                                    path:@"/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg"];
}

@end
