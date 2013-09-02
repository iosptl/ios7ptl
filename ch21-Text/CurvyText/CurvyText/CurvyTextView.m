//
//  CurvyTextView.m
//  CurvyText
//
//  Copyright (c) 2012, 2013 Rob Napier
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

static const CGFloat kControlPointSize = 13;

#import "CurvyTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CurvyTextView ()
@property (nonatomic, assign) CGPoint P0;
@property (nonatomic, assign) CGPoint P1;
@property (nonatomic, assign) CGPoint P2;
@property (nonatomic, assign) CGPoint P3;
@property (nonatomic, readwrite) NSLayoutManager *layoutManager;
@property (nonatomic, readwrite) NSTextStorage *textStorage;
@end

@implementation CurvyTextView

- (void)updateControlPoints {
  NSArray *subviews = self.subviews;
  self.P0 = [subviews[0] center];
  self.P1 = [subviews[1] center];
  self.P2 = [subviews[2] center];
  self.P3 = [subviews[3] center];
  [self setNeedsDisplay];
}

- (void)addControlPoint:(CGPoint)point color:(UIColor *)color {
  // Make the actual view 3x the size of the point, so it's easy to hit.
  CGRect fullRect = CGRectMake(0, 0, kControlPointSize*3, kControlPointSize*3);
  CGRect rect = CGRectInset(fullRect, kControlPointSize, kControlPointSize);
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
  shapeLayer.path = path;
  shapeLayer.fillColor = color.CGColor;
  CGPathRelease(path);

  UIView *view = [[UIView alloc] initWithFrame:fullRect];
  [view.layer addSublayer:shapeLayer];
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  [view addGestureRecognizer:g];
  [self addSubview:view];
  view.center = point;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self addControlPoint:CGPointMake(50, 500) color:[UIColor greenColor]];
      [self addControlPoint:CGPointMake(300, 300) color:[UIColor blackColor]];
      [self addControlPoint:CGPointMake(400, 700) color:[UIColor blackColor]];
      [self addControlPoint:CGPointMake(650, 500) color:[UIColor redColor]];
      [self updateControlPoints];

      _layoutManager = [NSLayoutManager new];
      NSTextContainer *textContainer = [NSTextContainer new]; // Inifinite-sized container.
      _textStorage = [[NSTextStorage alloc] init];

      [_layoutManager addTextContainer:textContainer];
      [_textStorage addLayoutManager:_layoutManager];

      self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)g {
  g.view.center = [g locationInView:self];
  [self updateControlPoints];
}

- (NSAttributedString *)attributedString {
  return self.textStorage;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
  [self.textStorage setAttributedString:attributedString];
}

- (void)drawPath {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:self.P0];
  [path addCurveToPoint:self.P3
          controlPoint1:self.P1
          controlPoint2:self.P2];
  [[UIColor blueColor] setStroke];
  [path stroke];  
}

static double Bezier(double t, double P0, double P1, double P2,
                     double P3) {
  return 
           (1-t)*(1-t)*(1-t)         * P0
     + 3 *       (1-t)*(1-t) *     t * P1
     + 3 *             (1-t) *   t*t * P2
     +                         t*t*t * P3;
}

- (CGPoint)pointForOffset:(double)t {
  double x = Bezier(t, _P0.x, _P1.x, _P2.x, _P3.x);
  double y = Bezier(t, _P0.y, _P1.y, _P2.y, _P3.y);
  return CGPointMake(x, y);
}

static double BezierPrime(double t, double P0, double P1,
                          double P2, double P3) {
  return
    -  3 * (1-t)*(1-t) * P0
    + (3 * (1-t)*(1-t) * P1) - (6 * t * (1-t) * P1)
    - (3 *         t*t * P2) + (6 * t * (1-t) * P2)
    +  3 * t*t * P3;
}

- (double)angleForOffset:(double)t {  
  double dx = BezierPrime(t, _P0.x, _P1.x, _P2.x, _P3.x);
  double dy = BezierPrime(t, _P0.y, _P1.y, _P2.y, _P3.y);  
  return atan2(dy, dx);
}

static double Distance(CGPoint a, CGPoint b) {
  CGFloat dx = a.x - b.x;
  CGFloat dy = a.y - b.y;
  return hypot(dx, dy);
}

// Simplistic routine to find the offset along Bezier that is
// aDistance away from aPoint. anOffset is the offset used to
// generate aPoint, and saves us the trouble of recalculating it
// This routine just walks forward until it finds a point at least
// aDistance away. Good optimizations here would reduce the number
// of guesses, but this is tricky since if we go too far out, the
// curve might loop back on leading to incorrect results. Tuning
// kStep is good start.
- (double)offsetAtDistance:(double)aDistance
                 fromPoint:(CGPoint)aPoint
                 andOffset:(double)anOffset {
  const double kStep = 0.001; // 0.0001 - 0.001 work well
  double newDistance = 0;
  double newOffset = anOffset + kStep;
  while (newDistance <= aDistance && newOffset < 1.0) {
    newOffset += kStep;
    newDistance = Distance(aPoint, 
                           [self pointForOffset:newOffset]);
  }
  return newOffset;
}

- (void)drawText {
  if ([self.attributedString length] == 0) { return; }

  NSLayoutManager *layoutManager = self.layoutManager;

  CGContextRef context = UIGraphicsGetCurrentContext();
  NSRange glyphRange;
  CGRect lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:0
                                                    effectiveRange:&glyphRange];

  double offset = 0;
  CGPoint lastGlyphPoint = self.P0;
  CGFloat lastX = 0;
  for (NSUInteger glyphIndex = glyphRange.location;
       glyphIndex < NSMaxRange(glyphRange);
       ++glyphIndex) {
    CGContextSaveGState(context);

    CGPoint location = [layoutManager locationForGlyphAtIndex:glyphIndex];

    CGFloat distance = location.x - lastX;  // Assume single line
    offset = [self offsetAtDistance:distance
                          fromPoint:lastGlyphPoint
                          andOffset:offset];
    CGPoint glyphPoint = [self pointForOffset:offset];
    double angle = [self angleForOffset:offset];

    lastGlyphPoint = glyphPoint;
    lastX = location.x;

    CGContextTranslateCTM(context, glyphPoint.x, glyphPoint.y);
    CGContextRotateCTM(context, angle);

    [layoutManager drawGlyphsForGlyphRange:NSMakeRange(glyphIndex, 1)
                                   atPoint:CGPointMake(-(lineRect.origin.x + location.x),
                                                       -(lineRect.origin.y + location.y))];

    CGContextRestoreGState(context);
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawPath];
  [self drawText];
}

@end
