//
//  FastCall.m
//  Runtime
//
//  Copyright (c) 2012 Rob Napier
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

#import "FastCall.h"

const NSUInteger kTotalCount = 100000000;

typedef void (*voidIMP)(id, SEL, ...);

void FastCall() {
  NSMutableString *string = [NSMutableString string];
  NSTimeInterval totalTime = 0;
  NSDate *start = nil;
  NSUInteger count = 0;
  
  // With objc_msgSend
  start = [NSDate date];
  for (count = 0; count < kTotalCount; ++count) {
    [string setString:@"stuff"];
  }
  
  totalTime = -[start timeIntervalSinceNow];
  printf("w/ objc_msgSend = %f\n", totalTime);
  
  // Skip objc_msgSend.
  start = [NSDate date];
  SEL selector = @selector(setString:);
  voidIMP
  setStringMethod = (voidIMP)[string methodForSelector:selector];
  
  for (count = 0; count < kTotalCount; ++count) {
    setStringMethod(string, selector, @"stuff");
  }
  
  totalTime = -[start timeIntervalSinceNow];
  printf("w/o objc_msgSend  = %f\n", totalTime);
}
