//
//  RNAssert.h
//  Defines assertion macros that log as well as crash, even when
//  in Release mode
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

#define RNLogBug NSLog // Use DDLogError if you’re using Lumberjack

// RNAssert and RNCAssert work exactly like NSAssert and NSCAssert
// except they log, even in release mode

#define RNAssert(condition, desc, ...) \
  if (!(condition)) { \
    RNLogBug((desc), ## __VA_ARGS__); \
    NSAssert((condition), (desc), ## __VA_ARGS__); \
  }

#define RNCAssert(condition, desc) \
  if (!(condition)) { \
    RNLogBug((desc), ## __VA_ARGS__); \
    NSCAssert((condition), (desc), ## __VA_ARGS__); \
  }