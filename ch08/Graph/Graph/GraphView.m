//
//  GraphView.m
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


#import "GraphView.h"

@implementation GraphView {
  dispatch_source_t _timer;
}

const CGFloat kXScale = 5.0;
const CGFloat kYScale = 100.0;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
    CGFloat dx, CGFloat dy) {
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

- (void)awakeFromNib {
  [self setContentMode:UIViewContentModeRight];
  _values = [NSMutableArray array];

  __weak id weakSelf = self;
  double delayInSeconds = 0.25;
  _timer =
      dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
          dispatch_get_main_queue());
  dispatch_source_set_timer(
      _timer, dispatch_walltime(NULL, 0),
      (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
  dispatch_source_set_event_handler(_timer, ^{
    [weakSelf updateValues];
  });
  dispatch_resume(_timer);
}

- (void)updateValues {
  double nextValue = sin(CFAbsoluteTimeGetCurrent())
      + ((double)rand()/(double)RAND_MAX);
  [self.values addObject:
      [NSNumber numberWithDouble:nextValue]];
  CGSize size = self.bounds.size;
  CGFloat maxDimension = MAX(size.height, size.width);
  NSUInteger maxValues =
      (NSUInteger)floorl(maxDimension / kXScale);

  if ([self.values count] > maxValues) {
    [self.values removeObjectsInRange:
        NSMakeRange(0, [self.values count] - maxValues)];
  }

  [self setNeedsDisplay];
}

- (void)dealloc {
  dispatch_source_cancel(_timer);
}

- (void)drawRect:(CGRect)rect {
  if ([self.values count] == 0) {
    return;
  }

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(ctx,
                                   [[UIColor redColor] CGColor]);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  CGContextSetLineWidth(ctx, 5);

  CGMutablePathRef path = CGPathCreateMutable();

  CGFloat yOffset = self.bounds.size.height / 2;
  CGAffineTransform transform =
      CGAffineTransformMakeScaleTranslate(kXScale, kYScale,
                                          0, yOffset);

  CGFloat y = [[self.values objectAtIndex:0] floatValue];
  CGPathMoveToPoint(path, &transform, 0, y);

  for (NSUInteger x = 1; x < [self.values count]; ++x) {
    y = [[self.values objectAtIndex:x] floatValue];
    CGPathAddLineToPoint(path, &transform, x, y);
  }

  CGContextAddPath(ctx, path);
  CGPathRelease(path);
  CGContextStrokePath(ctx);
}

@end
