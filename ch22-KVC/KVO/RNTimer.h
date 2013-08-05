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

#import <Foundation/Foundation.h>

/** Simple GCD-based timer based on NSTimer.

 Starts immediately and stops when deallocated. This avoids many of the typical problems with NSTimer:

 * RNTimer runs in all modes (unlike NSTimer)
 * RNTimer runs when there is no runloop (unlike NSTimer)
 * Repeating RNTimers can easily avoid retain loops (unlike NSTimer)
*/

@interface RNTimer : NSObject

/**---------------------------------------------------------------------------------------
 @name Creating a Timer
 -----------------------------------------------------------------------------------------
*/

/** Creates and returns a new repeating RNTimer object and starts running it

 After `seconds` seconds have elapsed, the timer fires, executing the block.
 You will generally need to use a weakSelf pointer to avoid a retain loop.
 The timer is attached to the main GCD queue.

 @param seconds The number of seconds between firings of the timer. Must be greater than 0.
 @param block Block to execute. Must be non-nil

 @return A new RNTimer object, configured according to the specified parameters.
*/
+ (RNTimer *)repeatingTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(void))block;


/**---------------------------------------------------------------------------------------
 @name Firing a Timer
 -----------------------------------------------------------------------------------------
*/

/** Causes the block to be executed.

 This does not modify the timer. It will still fire on schedule.
*/
- (void)fire;


/**---------------------------------------------------------------------------------------
 @name Stopping a Timer
 -----------------------------------------------------------------------------------------
*/

/** Stops the receiver from ever firing again

 Once invalidated, a timer cannot be reused.

*/
- (void)invalidate;
@end