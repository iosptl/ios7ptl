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

#import <XCTest/XCTest.h>

@interface SyncSemaphoreTests : XCTestCase

@end

@implementation SyncSemaphoreTests

- (void)testDownload {
  NSURL *URL = [NSURL URLWithString:@"http://iosptl.com"];

  // Block variables to hold results
  __block NSURL *location;
  __block NSError *error;

  // Create a synchronization semaphore
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

  [[[NSURLSession sharedSession] downloadTaskWithURL:URL
                                   completionHandler:
    ^(NSURL *l, NSURLResponse *r, NSError *e) {
      // Unload and test data
      location = l;
      error = e;

      // Signal that the operation has completed
      dispatch_semaphore_signal(semaphore);
    }] resume];

  // Setup the timeout
  double timeoutInSeconds = 2.0;
  dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW,
                                          (int64_t)(timeoutInSeconds * NSEC_PER_SEC));

  // Wait for the signal for a limited time
  long timeoutResult = dispatch_semaphore_wait(semaphore, timeout);

  // Test that everything worked
  XCTAssertEqual(timeoutResult, 0L, @"Timed out");
  XCTAssertNil(error, @"Received an error:%@", error);
  XCTAssertNotNil(location, @"Did not get a location");
}

@end
