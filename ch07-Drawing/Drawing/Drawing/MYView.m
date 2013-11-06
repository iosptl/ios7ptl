//
//  MYSmarterView.m
//  Drawing
//
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

#import "MYView.h"

@implementation MYView

- (UIImage *)reverseImageForText:(NSString *)text {
  const size_t kImageWidth = 200;
  const size_t kImageHeight = 200;
  CGImageRef textImage = NULL;
  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  UIColor *color = [UIColor redColor];
  
  UIGraphicsBeginImageContext(CGSizeMake(kImageWidth, kImageHeight));  

  [text drawInRect:CGRectMake(0, 0, kImageWidth, kImageHeight)
    withAttributes:@{
                     NSFontAttributeName: font,
                     NSForegroundColorAttributeName: color
                     }];

  textImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;

  UIGraphicsEndImageContext();

  return [UIImage imageWithCGImage:textImage
                             scale:1.0
                 orientation:UIImageOrientationUpMirrored];
}

- (void)drawRect:(CGRect)rect {
  [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.1] set];
  // Generate a bitmap, reverse it and draw it
  [[self reverseImageForText:@"Hello World"] drawAtPoint:CGPointMake(50, 150)];
  UIRectFillUsingBlendMode(CGRectMake(100, 100, 100, 100),kCGBlendModeNormal);
}

@end
