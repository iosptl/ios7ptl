// Based on PhotoScroller

#import "TilingView.h"
#import <QuartzCore/CATiledLayer.h>


@implementation TilingView
{
  NSString *_imageName;
}

+ (Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithImageName:(NSString *)name size:(CGSize)size
{
  self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
  if (self) {
    _imageName = name;

//    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
//    tiledLayer.levelsOfDetail = 4;
  }
  return self;
}

// to handle the interaction between CATiledLayer and high resolution screens, we need to
// always keep the tiling view's contentScaleFactor at 1.0. UIKit will try to set it back
// to 2.0 on retina displays, which is the right call in most cases, but since we're backed
// by a CATiledLayer it will actually cause us to load the wrong sized tiles.
//
- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
  [super setContentScaleFactor:1.f];
}

- (void)drawRect:(CGRect)rect
{
 	CGContextRef context = UIGraphicsGetCurrentContext();

  // get the scale from the context by getting the current transform matrix, then asking
  // for its "a" component, which is one of the two scale components. We could also ask
  // for "d". This assumes (safely) that the view is being scaled equally in both dimensions.
  CGFloat scale = CGContextGetCTM(context).a;

  CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
  CGSize tileSize = tiledLayer.tileSize;

  // Even at scales lower than 100%, we are drawing into a rect in the coordinate system
  // of the full image. One tile at 50% covers the width (in original image coordinates)
  // of two tiles at 100%. So at 50% we need to stretch our tiles to double the width
  // and height; at 25% we need to stretch them to quadruple the width and height; and so on.
  // (Note that this means that we are drawing very blurry images as the scale gets low.
  // At 12.5%, our lowest scale, we are stretching about 6 small tiles to fill the entire
  // original image area. But this is okay, because the big blurry image we're drawing
  // here will be scaled way down before it is displayed.)
  tileSize.width /= scale;
  tileSize.height /= scale;

  // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
  int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
  int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
  int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
  int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);

  for (int row = firstRow; row <= lastRow; row++) {
    for (int col = firstCol; col <= lastCol; col++) {
      UIImage *tile = [self tileForScale:scale row:row col:col];
      CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                   tileSize.width, tileSize.height);

      // if the tile would stick outside of our bounds, we need to truncate it so as
      // to avoid stretching out the partial tiles at the right and bottom edges
      tileRect = CGRectIntersection(self.bounds, tileRect);

      [tile drawInRect:tileRect];
    }
  }
}

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col
{
  // we use "imageWithContentsOfFile:" instead of "imageNamed:" here because we don't
  // want UIImage to cache our tiles
  //
  NSString *tileName = [NSString stringWithFormat:@"%@_%d_%d_%d.png", _imageName, (int)(scale * 1000), col, row];
  NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
  NSString *path = [cacheDir stringByAppendingPathComponent:tileName];
  UIImage *image = [UIImage imageWithContentsOfFile:path];
  return image;
}

@end
