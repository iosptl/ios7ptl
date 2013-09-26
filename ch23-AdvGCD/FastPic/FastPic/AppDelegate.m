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

  [self saveTilesOfSize:CGSizeMake(256, 256) forImage:[UIImage imageWithContentsOfFile:path] toDirectory:cacheDir usingPrefix:imageName];

  [(PhotoViewController *)self.window.rootViewController setImagePath:imageName size:CGSizeMake(5400, 2700)];
    // Override point for customization after application launch.
    return YES;
}

- (void)saveTilesOfSize:(CGSize)size
               forImage:(UIImage*)image
            toDirectory:(NSString*)directoryPath
            usingPrefix:(NSString*)prefix
{
  CGFloat cols = [image size].width / size.width;
  CGFloat rows = [image size].height / size.height;

  int fullColumns = floorf(cols);
  int fullRows = floorf(rows);

  CGFloat remainderWidth = [image size].width -
  (fullColumns * size.width);
  CGFloat remainderHeight = [image size].height -
  (fullRows * size.height);


  if (cols > fullColumns) fullColumns++;
  if (rows > fullRows) fullRows++;

  CGImageRef fullImage = [image CGImage];

  for (int y = 0; y < fullRows; ++y) {
    for (int x = 0; x < fullColumns; ++x) {
      CGSize tileSize = size;
      if (x + 1 == fullColumns && remainderWidth > 0) {
        // Last column
        tileSize.width = remainderWidth;
      }
      if (y + 1 == fullRows && remainderHeight > 0) {
        // Last row
        tileSize.height = remainderHeight;
      }

      CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,
                                                          (CGRect){{x*size.width, y*size.height},
                                                            tileSize});
      NSData *imageData = UIImagePNGRepresentation([UIImage imageWithCGImage:tileImage]);

      CGImageRelease(tileImage);

      NSString *path = [NSString stringWithFormat:@"%@/%@_1000_%d_%d.png",  // FIXME: Scale
                        directoryPath, prefix, x, y];
      [imageData writeToFile:path atomically:NO];
    }
  }    
}
@end
