//
//  BoxTransformViewController.m
//  BoxTransform
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

#import "BoxTransformViewController.h"

@implementation BoxTransformViewController

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./100.;

- (CALayer *)layerAtX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z 
                color:(UIColor *)color
            transform:(CATransform3D)transform {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [color CGColor];
  layer.bounds = CGRectMake(0, 0, kSize, kSize);
  layer.position = CGPointMake(x, y);
  layer.zPosition = z;
  layer.transform = transform;
  [self.contentLayer addSublayer:layer];
  return layer;
}

static CATransform3D MakeSideRotation(CGFloat x, CGFloat y, CGFloat z) {
  return CATransform3DMakeRotation(M_PI_2, x, y, z);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  CATransformLayer *contentLayer = [CATransformLayer layer];
  contentLayer.frame = self.view.layer.bounds;
  CGSize size = contentLayer.bounds.size;
  contentLayer.transform =
    CATransform3DMakeTranslation(size.width/2, size.height/2, 0);
  [self.view.layer addSublayer:contentLayer];
  
  self.contentLayer = contentLayer;
  
  self.topLayer = [self layerAtX:0 y:-kSize/2 z:0
                           color:[UIColor redColor] 
                       transform:MakeSideRotation(1, 0, 0)];
  
  self.bottomLayer = [self layerAtX:0 y:kSize/2 z:0
                              color:[UIColor greenColor]
                          transform:MakeSideRotation(1, 0, 0)];
  
  self.rightLayer = [self layerAtX:kSize/2 y:0 z:0 
                             color:[UIColor blueColor] 
                         transform:MakeSideRotation(0, 1, 0)];
  
  self.leftLayer = [self layerAtX:-kSize/2 y:0 z:0
                            color:[UIColor cyanColor]
                        transform:MakeSideRotation(0, 1, 0)];
  
  self.backLayer = [self layerAtX:0 y:0 z:-kSize/2
                            color:[UIColor yellowColor]
                        transform:CATransform3DIdentity];
  
  self.frontLayer = [self layerAtX:0 y:0 z:kSize/2
                             color:[UIColor magentaColor] 
                         transform:CATransform3DIdentity];
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(pan:)];
  [self.view addGestureRecognizer:g];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.view];
  CATransform3D transform = CATransform3DIdentity;
  transform = CATransform3DRotate(transform, 
                                  kPanScale * translation.x,
                                  0, 1, 0);
  transform = CATransform3DRotate(transform,
                                  -kPanScale * translation.y,
                                  1, 0, 0);
  self.view.layer.sublayerTransform = transform;
}

@end
