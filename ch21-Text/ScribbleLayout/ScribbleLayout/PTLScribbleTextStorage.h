//
//  PTLScribbleTextStorage.h
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//
// Based on Apple's TKDInteractiveTextColoringTextStorage sample code.


#import <UIKit/UIKit.h>

NSString * const PTLDefaultTokenName;

NSString * const PTLRedactStyleAttributeName;
NSString * const PTLHighlightColorAttributeName;

@interface PTLScribbleTextStorage : NSTextStorage
@property (nonatomic, readwrite, copy) NSDictionary *tokens; // maps tokens -> attributes
@end
