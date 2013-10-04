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

- (void)viewDidLoad
{
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
  NSLog(@"%@", getString);
  NSData *getData = [getString dataUsingEncoding:NSUTF8StringEncoding];

  dispatch_data_t data = dispatch_data_create(getData.bytes, getData.length, NULL, DISPATCH_DATA_DESTRUCTOR_DEFAULT);

  NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[kPath lastPathComponent]];
  dispatch_io_t fileChannel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, [writePath UTF8String], O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU, dispatch_get_main_queue(), nil);

  dispatch_io_write(serverChannel, 0, data, dispatch_get_global_queue(0, 0), ^(bool done, dispatch_data_t data, int error) {
    if (done) {
      [self readFromChannel:serverChannel toChannel:fileChannel];
    }
  });
}

- (void)readFromChannel:(dispatch_io_t)readChannel toChannel:(dispatch_io_t)writeChannel {
  dispatch_io_set_high_water(readChannel, 100);
  __block BOOL haveHeader = NO;
  __block NSData *lastLine;
  dispatch_io_read(readChannel, 0, SIZE_MAX, dispatch_get_global_queue(0, 0), ^(bool done, dispatch_data_t data, int error) {
    if (!haveHeader) {
      dispatch_data_apply(data, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
        printf("size:%zu\n", size);
        NSData *line;
        if (lastLine) {
          NSLog(@"temporary line");
          NSMutableData *newData = [lastLine mutableCopy];
          [newData appendBytes:buffer length:size];
          line = newData;
        }
        else {
          line = [[NSData alloc] initWithBytesNoCopy:(void*)buffer length:size freeWhenDone:NO];
        }

        NSLog(@"%@", [[NSString alloc] initWithData:line encoding:NSUTF8StringEncoding]);

        NSRange range = [line rangeOfData:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(0, [line length])];
        if (range.location == NSNotFound ) {
          char lastChar = ((char*)buffer)[size - 1];
          if( lastChar == '\r' || lastChar == '\n') {
            lastLine = line;
          }
        }
        else {
          haveHeader = YES;
          dispatch_io_set_high_water(readChannel, SIZE_MAX);
          // WRONG if reading the newline
          dispatch_data_t writeData = dispatch_data_create_subrange(region, NSMaxRange(range), [line length] - NSMaxRange(range));
          [self writeData:writeData toChannel:writeChannel];
        }
        return true;
      });
    }
    else {
      [self writeData:data toChannel:writeChannel];
    }
  });
}

- (void)writeData:(dispatch_data_t)data toChannel:(dispatch_io_t)channel {
  dispatch_io_write(channel, 0, data, dispatch_get_global_queue(0, 0), ^(bool done, dispatch_data_t data, int error){});
}

//
//            header = dispatch_data_create_concat(header, region);
//            const void *buffer;
//            size_t size;
//            dispatch_data_create_map(header, &buffer, &size);
//            if (memchr(<#const void *#>, <#int#>, <#size_t#>))
//
//            printf("--- %zu ---\n", size);
//          write(STDOUT_FILENO, buffer,size);
//          exit(0);


// Do any additional setup after loading the view, typically from a nib.



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
