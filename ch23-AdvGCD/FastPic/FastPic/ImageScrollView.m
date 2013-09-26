// Based on PhotoScroller

#import <Foundation/Foundation.h>

#import "ImageScrollView.h"
#import "TilingView.h"

static UIImage *_PlaceholderImageNamed(NSString *name);

#pragma mark -

@interface ImageScrollView () <UIScrollViewDelegate>
{
  UIImageView *_zoomView;  // if tiling, this contains a very low-res placeholder image,
  // otherwise it contains the full image.
  CGSize _imageSize;
  NSString *_imagePath;

  TilingView *_tilingView;

  CGPoint _pointToCenterAfterResize;
  CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  // center the zoom view as it becomes smaller than the size of the screen
  CGSize boundsSize = self.bounds.size;
  CGRect frameToCenter = _zoomView.frame;

  // center horizontally
  if (frameToCenter.size.width < boundsSize.width)
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
  else
    frameToCenter.origin.x = 0;

  // center vertically
  if (frameToCenter.size.height < boundsSize.height)
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
  else
    frameToCenter.origin.y = 0;

  _zoomView.frame = frameToCenter;
}

- (void)setFrame:(CGRect)frame
{
  BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);

  if (sizeChanging) {
    [self prepareToResize];
  }

  [super setFrame:frame];

  if (sizeChanging) {
    [self recoverFromResizing];
  }
}

- (void)setImagePath:(NSString *)path size:(CGSize)size {
  _imagePath = path;
  _imageSize = size;
  [self displayTiledImageNamed:_imagePath size:_imageSize]; // FIXME
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _zoomView;
}

#pragma mark - Configure scrollView to display new image (tiled or not)

- (void)displayTiledImageNamed:(NSString *)imageName size:(CGSize)imageSize
{
  // clear views for the previous image
  [_zoomView removeFromSuperview];
  _zoomView = nil;
  _tilingView = nil;

  // reset our zoomScale to 1.0 before doing any further calculations
  self.zoomScale = 1.0;

  // make views to display the new image
  _zoomView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, imageSize }];
  [_zoomView setImage:_PlaceholderImageNamed(imageName)];
  [self addSubview:_zoomView];

  _tilingView = [[TilingView alloc] initWithImageName:imageName size:imageSize];
  _tilingView.frame = _zoomView.bounds;
  [_zoomView addSubview:_tilingView];

  [self configureForImageSize:imageSize];
}

- (void)configureForImageSize:(CGSize)imageSize
{
  _imageSize = imageSize;
  self.contentSize = imageSize;
  [self setMaxMinZoomScalesForCurrentBounds];
  self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
  CGSize boundsSize = self.bounds.size;

  // calculate min/max zoomscale
  CGFloat xScale = boundsSize.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
  CGFloat yScale = boundsSize.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise

  // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
  BOOL imagePortrait = _imageSize.height > _imageSize.width;
  BOOL phonePortrait = boundsSize.height > boundsSize.width;
  CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);

  // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
  // maximum zoom scale to 0.5.
  CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];

  // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
  if (minScale > maxScale) {
    minScale = maxScale;
  }

  self.maximumZoomScale = maxScale;
  self.minimumZoomScale = minScale;
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

#pragma mark - Rotation support

- (void)prepareToResize
{
  CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];

  _scaleToRestoreAfterResize = self.zoomScale;

  // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
  // allowable scale when the scale is restored.
  if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
    _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
  [self setMaxMinZoomScalesForCurrentBounds];

  // Step 1: restore zoom scale, first making sure it is within the allowable range.
  CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
  self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);

  // Step 2: restore center point, first making sure it is within the allowable range.

  // 2a: convert our desired center point back to our own coordinate space
  CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];

  // 2b: calculate the content offset that would yield that center point
  CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                               boundsCenter.y - self.bounds.size.height / 2.0);

  // 2c: restore offset, adjusted to be within the allowable range
  CGPoint maxOffset = [self maximumContentOffset];
  CGPoint minOffset = [self minimumContentOffset];

  CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
  offset.x = MAX(minOffset.x, realMaxOffset);

  realMaxOffset = MIN(maxOffset.y, offset.y);
  offset.y = MAX(minOffset.y, realMaxOffset);

  self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
  CGSize contentSize = self.contentSize;
  CGSize boundsSize = self.bounds.size;
  return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
  return CGPointZero;
}

@end

static UIImage *_PlaceholderImageNamed(NSString *name)
{
  return [UIImage imageNamed:[NSString stringWithFormat:@"%@_Placeholder", name]];
}
