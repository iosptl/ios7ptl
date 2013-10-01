//
//  RNQueue.h
//
//  Simple utilities to simplify common assertions about the "current queue."
//  dispatch_get_current_queue() was deprecated back in iOS 6 because it's really not well defined,
//  and it's very easy to create deadlock if you're not very careful.
//  See https://devforums.apple.com/thread/162529 for some background on that.
//
//  These functions are meant to handle the most common use cases for dispatch_get_current_queue()
//  by replacing them with queues "tagged" with queue specific data via dispatch_queue_set_specific().
//
//  The most common usage is like this:
//    self.queue = RNQueueCreateTagged("queue", DISPATCH_QUEUE_SERIAL);
//    ...
//    - (void)doSomethingOnlyFromQueue {
//      RNAssertQueue(self.queue);
//      ...
//
//    - (void)doUIStuff {
//      RNAssertMainQueue();
//      ...
//
//      RNQueueSafeDispatchSync(self.queue, ^{ NSLog(@"Please don't deadlock"); });

//
//  Created by Rob Napier on 9/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tag a queue for later use with RNQueueCurrentIsTaggedQueue
void RNQueueTag(dispatch_queue_t q);

// Convenience wrapper around dispatch_queue_create.
dispatch_queue_t RNQueueCreateTagged(const char *label,
                                     dispatch_queue_attr_t attr);

// Returns YES if the current queue is within q's hierarchy.
BOOL RNQueueCurrentIsTaggedQueue(dispatch_queue_t q);

// Returns the closest tagged queue in the hierarchy
dispatch_queue_t RNQueueGetCurrentTagged();

// Returns YES if the "current" queue is the main queue
// (Technically checks that the current thread is the main thread.)
BOOL RNQueueCurrentIsMainQueue();

// Synchronously dispatches block to q "safely." If q is part of the current queue hierarchy, then
// block is immediately run, otherwise it is dispatched to q.
void RNQueueSafeDispatchSync(dispatch_queue_t q, dispatch_block_t block);

// Assert that the q is within the current queue hierarchy
#define RNAssertQueue(q) NSAssert(RNQueueCurrentIsTaggedQueue(q), @"Must run on queue: " #q )

// Assert that the current queue is the main queue
#define RNAssertMainQueue() NSAssert(RNQueueCurrentIsMainQueue(), @"Must run on main queue");
