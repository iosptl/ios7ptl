//
//  SyncSemaphoreTests.m
//  SyncSemaphoreTests
//
//  Created by Rob Napier on 9/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SyncSemaphoreTests : XCTestCase

@end

@implementation SyncSemaphoreTests

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

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
