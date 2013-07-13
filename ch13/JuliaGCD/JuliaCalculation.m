//
//  JuliaOperation.m
//  Julia
//
//  Created by Rob Napier on 8/7/12.
//

#import "JuliaCalculation.h"

@interface JuliaCalculation ()
@property (nonatomic, readwrite, strong) UIImage *image;
@end

@implementation JuliaCalculation

complex long double f(complex long double z, complex long double c) {
  return z*z + c;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"(%.3f, %.3f)@%.2f",
          creal(self.c), cimag(self.c), self.contentScaleFactor];
}

- (void)cancel {
  self.image = nil;
  self.cancelled = YES;
}

- (BOOL)run
{
  if (self.isCancelled) {
    return NO;
  }
  
//  NSLog(@"Running: %@", self);
  NSUInteger height = self.height;
  NSUInteger width = self.width;
  
  NSUInteger components = 4;
  NSMutableData *
  data = [NSMutableData dataWithLength:
          width * height * components * sizeof(uint8_t)];
  uint8_t *bits = [data mutableBytes];
  
  complex long double c = self.c;
  long double blowup = self.blowup;
  const double kScale = 1.5;
  
  for (NSUInteger y = 0; y < height; ++y) {
    for (NSUInteger x = 0; x < width; ++x) {
      if (self.isCancelled) {
//        NSLog(@"Cancelled: %@", self);
        return NO;
      }
      NSUInteger iteration = 0;
      complex long double z = (2.0 * kScale * x)/width - kScale
      + I*((2.0 * kScale * y)/width - kScale);
      while (cabsl(z) < blowup && iteration < 256) {
        z = f(z, c);
        ++iteration;
      }
      
      NSUInteger offset = (y*width*components) + (x*components);
      bits[offset+0] = (iteration * self.rScale);
      bits[offset+1] = (iteration * self.bScale);
      bits[offset+2] = (iteration * self.gScale);
    }
  }
  
  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(bits,
                                               width,
                                               height,
                                               8,
                                               width * components,
                                               colorspace,
                                               kCGImageAlphaNoneSkipLast);
  CGColorSpaceRelease(colorspace);
  
  CGImageRef cgImage = CGBitmapContextCreateImage(context);
  self.image = [UIImage imageWithCGImage:cgImage
                                       scale:self.contentScaleFactor
                                 orientation:UIImageOrientationUp];
  CGImageRelease(cgImage);
  CGContextRelease(context);
//  NSLog(@"Finished: %@", self);
  return YES;
}

@end
