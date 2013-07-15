//
//  CircleView.m
//  ViewAnimation
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = NO;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIColor redColor] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
}

@end
