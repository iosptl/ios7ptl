//
//  PathTextContainer.h
//  CircleLayout
//
//  Created by Rob Napier on 8/27/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathTextContainer : NSTextContainer
@property (nonatomic, readwrite, copy) UIBezierPath *path;
@end
