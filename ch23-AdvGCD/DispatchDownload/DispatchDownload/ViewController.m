//
//  Copyright (c) 2013 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "ViewController.h"
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

NSString * const kHeaderDelimiterString = @"\r\n\r\n";

@implementation ViewController

- (NSData *)headerDelimiter {
  static NSData *data;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    data = [kHeaderDelimiterString dataUsingEncoding:NSUTF8StringEncoding];
  });

  return data;
}

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
  return [NSTemporaryDirectory() stringByAppendingPathComponent:[path lastPathComponent]];
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

- (void)handleDoneWithChannels:(NSArray *)channels {
  NSLog(@"Done Downloading");
  for (dispatch_io_t channel in channels) {
    dispatch_io_close(channel, 0);
  }
}

- (dispatch_data_t)findHeaderInData:(dispatch_data_t)newData
                       previousData:(dispatch_data_t *)previousData
                       writeChannel:(dispatch_io_t)writeChannel
                              queue:(dispatch_queue_t)queue {


  // Glue the previous data to new data. This is a cheap operation.
  *previousData = dispatch_data_create_concat(*previousData,
                                              newData);

  // Create a contiguous memory region. This requires a memory copy.
  dispatch_data_t mappedData = dispatch_data_create_map(*previousData,
                                                        NULL, NULL);

  __block dispatch_data_t headerData;
  __block dispatch_data_t bodyData;

  // The dispatch_data_apply is unnecessary; we could have gotten
  // buffer and size from dispatch_data_create_map, but this shows
  // how to use dispatch_data_apply, and there are subtle ARC issues
  // with accessing the values through dispatch_data_create_map. We
  // have to be careful that mappedData doesn't get released immediately.
  dispatch_data_apply(mappedData,
    ^bool(dispatch_data_t region, size_t offset,
          const void *buffer, size_t size) {

      // We know that region is all the data because we just mapped it.
      // Convert it into an NSData for simpler searching.
      NSData *search =
      [[NSData alloc] initWithBytesNoCopy:(void*)buffer
                                   length:size
                             freeWhenDone:NO];
      NSRange r =
      [search rangeOfData:[self headerDelimiter]
                  options:0
                    range:NSMakeRange(0,
                                      search.length)];

      // If we found the delimiter, split into header and body
      if (r.location != NSNotFound) {
        headerData = dispatch_data_create_subrange(region,
                                                   0,
                                                   r.location);
        size_t body_offset = NSMaxRange(r);
        size_t body_size = size - body_offset;
        bodyData = dispatch_data_create_subrange(region,
                                                 body_offset,
                                                 body_size);
      }

      // We only need to process one block
      return false;
    });

  if (bodyData) {
    [self writeToChannel:writeChannel
                    data:bodyData
                   queue:queue];
  }
  return headerData;
}

- (void)printHeader:(dispatch_data_t)headerData {
  printf("\nHeader:\n\n");
  dispatch_data_apply(headerData, ^bool(dispatch_data_t region,
                                        size_t offset,
                                        const void *buffer,
                                        size_t size) {
    fwrite(buffer, size, 1, stdout);
    return true;
  });
  printf("\n\n");

}

- (void)readFromChannel:(dispatch_io_t)readChannel
         writeToChannel:(dispatch_io_t)writeChannel
                  queue:(dispatch_queue_t)queue {

  __block dispatch_data_t previousData = dispatch_data_empty;
  __block dispatch_data_t headerData;
  dispatch_io_read(readChannel, 0, SIZE_MAX, queue,
   ^(bool serverReadDone,
     dispatch_data_t serverReadData,
     int serverReadError) {

     NSAssert(!serverReadError,
              @"Server read error:%d", serverReadError);
     if (serverReadDone) {
       [self handleDoneWithChannels:@[writeChannel,
                                      readChannel]];
     }
     else {
       if (! headerData) {
         headerData = [self findHeaderInData:serverReadData
                                previousData:&previousData
                                writeChannel:writeChannel
                                       queue:queue];
         if (headerData) {
           [self printHeader:headerData];
         }
       }
       else {
         [self writeToChannel:writeChannel
                         data:serverReadData
                        queue:queue];
       }
     }
   });
}

- (dispatch_data_t)requestDataForHostName:(NSString *)hostName
                                     path:(NSString *)path {
  NSString *
  getString = [NSString
               stringWithFormat:@"GET %@ HTTP/1.1\r\nHost: %@\r\n\r\n",
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
