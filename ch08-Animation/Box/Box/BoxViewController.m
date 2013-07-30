//
//  BoxViewController.m
//  Box
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

#import "BoxViewController.h"

@implementation BoxViewController

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./100.;

- (CALayer *)layerWithColor:(UIColor *)color
                  transform:(CATransform3D)transform {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [color CGColor];
  layer.bounds = CGRectMake(0, 0, kSize, kSize);
  layer.position = self.view.center;
  layer.transform = transform;
  [self.view.layer addSublayer:layer];
  return layer;
}

static CATransform3D MakePerspetiveTransform() {
  CATransform3D perspective = CATransform3DIdentity;
  perspective.m34 = -1./2000.;
  return perspective;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  CATransform3D transform;
  transform = CATransform3DMakeTranslation(0, -kSize/2, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
  self.topLayer = [self layerWithColor:[UIColor redColor] 
                             transform:transform];
  
  transform = CATransform3DMakeTranslation(0, kSize/2, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
  self.bottomLayer = [self layerWithColor:[UIColor greenColor]
                                transform:transform];

  transform = CATransform3DMakeTranslation(kSize/2, 0, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
  self.rightLayer = [self layerWithColor:[UIColor blueColor] 
                               transform:transform];
  
  transform = CATransform3DMakeTranslation(-kSize/2, 0, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
  self.leftLayer = [self layerWithColor:[UIColor cyanColor]
                              transform:transform];
  
  transform = CATransform3DMakeTranslation(0, 0, -kSize/2);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
  self.backLayer = [self layerWithColor:[UIColor yellowColor]
                              transform:transform];
  
  transform = CATransform3DMakeTranslation(0, 0, kSize/2);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
  self.frontLayer = [self layerWithColor:[UIColor magentaColor] 
                               transform:transform];

  self.view.layer.sublayerTransform = MakePerspetiveTransform();  
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(pan:)];
  [self.view addGestureRecognizer:g];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.view];
  CATransform3D transform = MakePerspetiveTransform();
  transform = CATransform3DRotate(transform, 
                                  kPanScale * translation.x,
                                  0, 1, 0);
  transform = CATransform3DRotate(transform,
                                  -kPanScale * translation.y,
                                  1, 0, 0);
  self.view.layer.sublayerTransform = transform;
}

@end
