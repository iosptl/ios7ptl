//
//  CoreTextLabel.m
//  SimpleLayout
//
//  Created by Rob Napier on 8/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreTextLabel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@implementation CoreTextLabel
@synthesize attributedString=attributedString_;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    CGAffineTransform 
    transform = CGAffineTransformMakeScale(1, -1);
    CGAffineTransformTranslate(transform, 
                               0,
                               -self.bounds.size.height);
    self.transform = transform;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setAttributedString:(NSAttributedString *)anAttributedString {
  if (anAttributedString != attributedString_) {
    attributedString_ = [anAttributedString copy];
    [self setNeedsDisplay];
  }
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  
  CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
  
  CFAttributedStringRef
  attrString = (__bridge CFTypeRef)self.attributedString;
  
  // Create the framesetter using the attributed string
  CTFramesetterRef
  framesetter = CTFramesetterCreateWithAttributedString(attrString);
  
  // Create a single frame using the entire string (CFRange(0,0))
  // that fits inside of path.
  CTFrameRef
  frame = CTFramesetterCreateFrame(framesetter,
                                   CFRangeMake(0, 0),
                                   path, 
                                   NULL);
  
  // Draw the frame into the current context
  CTFrameDraw(frame, context);
  
  CFRelease(frame);
  CFRelease(framesetter);
  CGPathRelease(path);
}

@end
