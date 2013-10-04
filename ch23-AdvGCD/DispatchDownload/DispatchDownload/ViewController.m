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

NSString * const kDownloadURLString = @"http://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg";
const char * kHost = "upload.wikimedia.org";
const int kPort = 80;
NSString * const kPath = @"/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  int s;
  struct sockaddr_in sa;
  struct hostent *he;

  if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
    NSAssert(NO, @"socket failed:%d", errno);
  }

  bzero(&sa, sizeof sa);

  sa.sin_family = AF_INET;
  sa.sin_port = htons(kPort);

  if ((he = gethostbyname(kHost)) == NULL) {
    NSAssert(NO, @"gethostbyname failure:%d", errno);
  }

  bcopy(he->h_addr_list[0], &sa.sin_addr, he->h_length);

  if (connect(s, (struct sockaddr *)&sa, sizeof sa) < 0) {
    close(s);
    NSAssert(NO, @"connect failed:%d", errno);
  }

  dispatch_io_t serverChannel = dispatch_io_create(DISPATCH_IO_STREAM, s, dispatch_get_main_queue(), ^(int error){
    close(s);
  });

  NSString *getString = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %s\r\n\r\n", kPath, kHost];
  NSLog(@"Request:\n%@", getString);
  NSData *getData = [getString dataUsingEncoding:NSUTF8StringEncoding];

  dispatch_data_t data = dispatch_data_create(getData.bytes, getData.length, NULL, DISPATCH_DATA_DESTRUCTOR_DEFAULT);

  NSString *writePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[kPath lastPathComponent]] stringByAppendingPathExtension:@"out"];
  NSLog(@"Writing to %@", writePath);
  dispatch_io_t fileChannel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, [writePath UTF8String], O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU, dispatch_get_main_queue(), nil);

  dispatch_queue_t queue = dispatch_queue_create("DispatchDownload", DISPATCH_QUEUE_CONCURRENT);

  dispatch_io_write(serverChannel, 0, data, queue, ^(bool serverWriteDone, dispatch_data_t serverWriteData, int serverWriteError) {
    NSAssert(serverWriteError == 0, @"Server write error:%d", serverWriteError);
    if (serverWriteDone) {
      dispatch_io_read(serverChannel, 0, SIZE_MAX, queue, ^(bool serverReadDone, dispatch_data_t serverReadData, int serverReadError) {
        NSAssert(serverReadError == 0, @"Server read error:%d", serverReadError);
        if (serverReadDone) {
          NSLog(@"Done");
          dispatch_io_close(fileChannel, 0);
          dispatch_io_close(serverChannel, 0);
        }
        else {
          dispatch_io_write(fileChannel, 0, serverReadData, queue, ^(bool fileWriteDone, dispatch_data_t fileWriteRemainingData, int fileWriteError) {
            NSAssert(fileWriteError == 0, @"File write error:%d", fileWriteError);
            size_t unwrittenDataLength = 0;
            if (fileWriteRemainingData) {
              unwrittenDataLength = dispatch_data_get_size(fileWriteRemainingData);
            }
            NSLog(@"Wrote %zu bytes", dispatch_data_get_size(serverReadData) - unwrittenDataLength);
          });
        }
      });
    }
  });
}

@end
