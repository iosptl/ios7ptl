//
// CircleTextContainer
// Originally based on code from Apple's TextLayoutDemo. Recalculated to deal with exclusion paths


#import "CircleTextContainer.h"

@implementation CircleTextContainer

- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect
                                  atIndex:(NSUInteger)characterIndex
                         writingDirection:(NSWritingDirection)baseWritingDirection
                            remainingRect:(CGRect *)remainingRect {

  CGRect rect = [super lineFragmentRectForProposedRect:proposedRect
                                               atIndex:characterIndex
                                      writingDirection:baseWritingDirection
                                         remainingRect:remainingRect];

  CGSize size = [self size];
  CGFloat radius = fmin(size.width, size.height) / 2.0;
  CGFloat ypos = fabs((proposedRect.origin.y +
                       proposedRect.size.height / 2.0) - radius);
  CGFloat width = (ypos < radius) ? 2.0 * sqrt(radius * radius
                                               - ypos * ypos) : 0.0;
  CGRect circleRect = CGRectMake(radius - width / 2.0,
                                 proposedRect.origin.y,
                                 width,
                                 proposedRect.size.height);

  return CGRectIntersection(rect, circleRect);
}


@end
