//
//  LayerView.m
//  Layer
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

#import "LayerView.h"

@implementation LayerView

- (void)drawRect:(CGRect)rect {
  static CGLayerRef sTextLayer = NULL;

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  if (sTextLayer == NULL) {
    CGRect textBounds = CGRectMake(0, 0, 200, 100);
    sTextLayer = CGLayerCreateWithContext(ctx, 
                                          textBounds.size, 
                                          NULL);

    CGContextRef textCtx = CGLayerGetContext(sTextLayer);
    CGContextSetRGBFillColor (textCtx, 1.0, 0.0, 0.0, 1);
    UIGraphicsPushContext(textCtx);
    UIFont *font = [UIFont systemFontOfSize:13.0];
    [@"Pushing The Limits" drawInRect:textBounds 
                             withFont:font];
    UIGraphicsPopContext();
  }
  
  CGContextTranslateCTM(ctx, self.bounds.size.width / 2,
                        self.bounds.size.height / 2);
  
  for (NSUInteger i = 0; i < 10; ++i) {
    CGContextRotateCTM(ctx, (CGFloat)(2 * M_PI / 10));
    CGContextDrawLayerAtPoint(ctx, 
                              CGPointZero,
                              sTextLayer);
  }
}

@end
