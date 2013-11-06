//
//  DecorationViewController.m
//  Decoration
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

#import "DecorationViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DecorationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CALayer *layer;
  layer = [CALayer layer];
  layer.frame = CGRectMake(100, 100, 100, 100);
  layer.cornerRadius = 10;
  layer.backgroundColor = [[UIColor redColor] CGColor];
  layer.borderColor = [[UIColor blueColor] CGColor];
  layer.borderWidth = 5;
  layer.shadowOpacity = 0.5;
  layer.shadowOffset = CGSizeMake(3.0, 3.0);
  [self.view.layer addSublayer:layer];
  
  layer = [CALayer layer];
  layer.frame = CGRectMake(150, 150, 100, 100);
  layer.cornerRadius = 10;
  layer.backgroundColor = [[UIColor greenColor] CGColor];
  layer.borderWidth = 5;
  layer.shadowOpacity = 0.5;
  layer.shadowOffset = CGSizeMake(3.0, 3.0);
  [self.view.layer addSublayer:layer];
}

@end
