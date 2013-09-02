//
//  MBHShapeCell.m
//  MrBlockhead
//
//  Created by Rob Napier on 9/2/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import "MBHShapeCell.h"

@interface MBHShapeCell ()
@property (nonatomic, readwrite, strong) CAShapeLayer *shapeLayer;
@end

@implementation MBHShapeCell

- (void)awakeFromNib {
  _shapeLayer = [[CAShapeLayer alloc] init];
  _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
  _shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
  [self.contentView.layer addSublayer:_shapeLayer];
}

- (UIBezierPath *)path {
  return [UIBezierPath bezierPathWithCGPath:self.shapeLayer.path];
}

- (void)setPath:(UIBezierPath *)path {
  self.shapeLayer.path = path.CGPath;
}

@end
