//
//  JuliaOperation.h
//  Julia
//
//  Created by Rob Napier on 8/7/12.
//

#import <Foundation/Foundation.h>
#import <complex.h>

@interface JuliaCalculation : NSObject
@property (nonatomic, readwrite, assign) NSUInteger width;
@property (nonatomic, readwrite, assign) NSUInteger height;
@property (nonatomic, readwrite, assign) complex long double c;
@property (nonatomic, readwrite, assign) complex long double blowup;
@property (nonatomic, readwrite, assign) CGFloat contentScaleFactor;
@property (nonatomic, readwrite, assign) NSUInteger rScale;
@property (nonatomic, readwrite, assign) NSUInteger gScale;
@property (nonatomic, readwrite, assign) NSUInteger bScale;
@property (nonatomic, readonly, strong) UIImage *image;

@property (nonatomic, readwrite, assign, getter=isCancelled) BOOL cancelled;
- (BOOL)run;
@end
