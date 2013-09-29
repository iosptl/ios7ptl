//
//  AppDelegate.m
//  FastPic
//
//  Created by Rob Napier on 9/26/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSString *imageName = @"world.topo.bathy.200412.3x5400x2700";
  NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];

  // Refactor duplicate
  NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

  UIImage *image = ^{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    UIImage *i = [UIImage imageWithContentsOfFile:path];
    NSLog(@"Time=%f", CFAbsoluteTimeGetCurrent() - start);
    return i;
  };


  [self saveTilesOfSize:CGSizeMake(256, 256) forImage:image toDirectory:cacheDir usingPrefix:imageName];

  NSProgress *progress = [NSProgress progressWithTotalUnitCount:(5400*2700)];

  PhotoViewController *photoViewController = (PhotoViewController *)self.window.rootViewController;
  [photoViewController setProgress:progress];
  [photoViewController setImagePath:imageName size:CGSizeMake(5400, 2700)];
  // Override point for customization after application launch.
  return YES;
}

//- (void)saveTilesOfSize:(CGSize)size
//               forImage:(UIImage*)image
//            toDirectory:(NSString*)directoryPath
//            usingPrefix:(NSString*)prefix
//{
//  CGFloat cols = [image size].width / size.width;
//  CGFloat rows = [image size].height / size.height;
//
//  int fullColumns = floorf(cols);
//  int fullRows = floorf(rows);
//
//  CGFloat remainderWidth = [image size].width -
//  (fullColumns * size.width);
//  CGFloat remainderHeight = [image size].height -
//  (fullRows * size.height);
//
//
//  if (cols > fullColumns) fullColumns++;
//  if (rows > fullRows) fullRows++;
//
//  CGImageRef fullImage = [image CGImage];
//
//  for (int y = 0; y < fullRows; ++y) {
//    for (int x = 0; x < fullColumns; ++x) {
//      CGSize tileSize = size;
//      if (x + 1 == fullColumns && remainderWidth > 0) {
//        // Last column
//        tileSize.width = remainderWidth;
//      }
//      if (y + 1 == fullRows && remainderHeight > 0) {
//        // Last row
//        tileSize.height = remainderHeight;
//      }
//
//      CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,
//                                                          (CGRect){{x*size.width, y*size.height},
//                                                            tileSize});
//      NSData *imageData = UIImagePNGRepresentation([UIImage imageWithCGImage:tileImage]);
//
//      CGImageRelease(tileImage);
//
//      NSString *path = [NSString stringWithFormat:@"%@/%@_1000_%d_%d.png",  // FIXME: Scale
//                        directoryPath, prefix, x, y];
//      [imageData writeToFile:path atomically:NO];
//    }
//  }
//}

#define bytesPerMB 1048576.0f
#define bytesPerPixel 4.0f
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destTotalPixels kDestImageSizeMB * pixelsPerMB
#   define kDestImageSizeMB 120.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 40.0f // The tile size will be (x)MB of uncompressed image data.
#define tileTotalPixels kSourceImageTileSizeMB * pixelsPerMB
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.

- (void)saveTilesOfSize:(CGSize)size
           forImagePath:(NSString*)imagePath
            toDirectory:(NSString*)directoryPath {

  // Lazy-load image. This does not actually decode the image into memory
  UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
  NSAssert(sourceImage, @"Could not load image.");

  CGSize sourceResolution;
  sourceResolution.width = CGImageGetWidth(sourceImage.CGImage);
  sourceResolution.height = CGImageGetHeight(sourceImage.CGImage);

  CGFloat sourceTotalPixels = sourceResolution.width * sourceResolution.height;
  CGFloat sourceTotalMB = sourceTotalPixels / pixelsPerMB;

  CGFloat imageScale = destTotalPixels / sourceTotalPixels;

  CGSize destResolution;
  destResolution.width = (int)( sourceResolution.width * imageScale );
  destResolution.height = (int)( sourceResolution.height * imageScale );

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  int bytesPerRow = bytesPerPixel * destResolution.width;
  void* destBitmapData = malloc( bytesPerRow * destResolution.height );
  NSAssert(destBitmapData, @"failed to allocate space for the output image!");

  CGContextRef destContext = CGBitmapContextCreate( destBitmapData, destResolution.width, destResolution.height, 8, bytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast );
  NSAssert(destContext, @"failed to create the output bitmap context!");

  CGColorSpaceRelease( colorSpace );

  CGContextTranslateCTM( destContext, 0.0f, destResolution.height );
  CGContextScaleCTM( destContext, 1.0f, -1.0f );

  CGRect sourceTile;
  sourceTile.size.width = sourceResolution.width;

  sourceTile.size.height = (int)( tileTotalPixels / sourceTile.size.width );
  NSLog(@"source tile size: %f x %f",sourceTile.size.width, sourceTile.size.height);
  sourceTile.origin.x = 0.0f;

  CGRect destTile;
  destTile.size.width = destResolution.width;
  destTile.size.height = sourceTile.size.height * imageScale;
  destTile.origin.x = 0.0f;
  NSLog(@"dest tile size: %f x %f",destTile.size.width, destTile.size.height);

  CGFloat sourceSeemOverlap = (int)( ( destSeemOverlap / destResolution.height ) * sourceResolution.height );
  NSLog(@"dest seem overlap: %f, source seem overlap: %f",destSeemOverlap, sourceSeemOverlap);
  CGImageRef sourceTileImageRef;
  // calculate the number of read/write opertions required to assemble the
  // output image.
  int iterations = (int)( sourceResolution.height / sourceTile.size.height );
  // if tile height doesn't divide the image height evenly, add another iteration
  // to account for the remaining pixels.
  int remainder = (int)sourceResolution.height % (int)sourceTile.size.height;
  if( remainder ) iterations++;
  // add seem overlaps to the tiles, but save the original tile height for y coordinate calculations.
  float sourceTileHeightMinusOverlap = sourceTile.size.height;
  sourceTile.size.height += sourceSeemOverlap;
  destTile.size.height += destSeemOverlap;
  NSLog(@"beginning downsize. iterations: %d, tile height: %f, remainder height: %d", iterations, sourceTile.size.height,remainder );

  for( int y = 0; y < iterations; ++y ) {
    @autoreleasepool {
      NSLog(@"iteration %d of %d",y+1,iterations);
      sourceTile.origin.y = y * sourceTileHeightMinusOverlap + sourceSeemOverlap;
      destTile.origin.y = ( destResolution.height ) - ( ( y + 1 ) * sourceTileHeightMinusOverlap * imageScale + destSeemOverlap );

      sourceTileImageRef = CGImageCreateWithImageInRect( sourceImage.CGImage, sourceTile );

      if( y == iterations - 1 && remainder ) {
        float dify = destTile.size.height;
        destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * imageScale;
        dify -= destTile.size.height;
        destTile.origin.y += dify;
      }
      CGContextDrawImage( destContext, destTile, sourceTileImageRef );
      CGImageRelease( sourceTileImageRef );
      sourceImage = nil;
    }
    // we reallocate the source image after the pool is drained since UIImage -imageNamed
    // returns us an autoreleased object.
    if( y < iterations - 1 ) {
      sourceImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
      [self performSelectorOnMainThread:@selector(updateScrollView:) withObject:nil waitUntilDone:YES];
    }
  }
  NSLog(@"downsize complete.");
  [self performSelectorOnMainThread:@selector(initializeScrollView:) withObject:nil waitUntilDone:YES];
  // free the context since its job is done. destImageRef retains the pixel data now.
  CGContextRelease( destContext );
  [pool drain];
}

@end
