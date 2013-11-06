//
//  RNTimer
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


#import "RNTimer.h"

@interface RNTimer ()
@property (nonatomic, readwrite, copy) void (^block)();
@property (nonatomic, readwrite, strong) dispatch_source_t source;
@end

@implementation RNTimer
@synthesize block = _block;
@synthesize source = _source;

+ (RNTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(void))block
{
  NSParameterAssert(seconds);
  NSParameterAssert(block);

  RNTimer *timer = [[self alloc] init];
  timer.block = block;
  timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
      dispatch_get_main_queue());
  uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
  dispatch_source_set_timer(timer.source, dispatch_time(DISPATCH_TIME_NOW, nsec),
                            nsec, 0);
  dispatch_source_set_event_handler(timer.source, block);
  dispatch_resume(timer.source);
  return timer;
}

- (void)invalidate
{
  if (self.source) {
    dispatch_source_cancel(self.source);
    self.source = nil;
  }
  self.block = nil;
}

- (void)dealloc
{
  [self invalidate];
}

- (void)fire
{
  self.block();
}


@end