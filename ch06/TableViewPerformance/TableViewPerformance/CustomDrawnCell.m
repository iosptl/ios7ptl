//
//  CustomDrawnCell.m
//  TableViewPerformance
//
//  Created by Mugunth Kumar on 7/11/11.
//

#import "CustomDrawnCell.h"

@implementation CustomDrawnCell

static UIFont *titleFont = nil;
static UIFont *subTitleFont = nil;
static UIFont *timeTitleFont = nil;

- (void)setTitle:(NSString*) aTitle subTitle:(NSString*) aSubTitle time:(NSString*) aTimeTitle thumbnail:(UIImage *)aThumbnail
{
    if (_title != aTitle) {
        _title = aTitle;        
    }
    
    if (_subTitle != aSubTitle) {
        _subTitle = aSubTitle;
    }

    if (_timeTitle != aTimeTitle) {
        _timeTitle = aTimeTitle;
    }

    if (_thumbnail != aThumbnail) {
        _thumbnail = aThumbnail;        
    }
    
    [self setNeedsDisplay];
}

+(void) initialize
{
    titleFont = [UIFont systemFontOfSize:17];
    subTitleFont = [UIFont systemFontOfSize:13];
    timeTitleFont = [UIFont systemFontOfSize:10];
}

+(void) dealloc
{
    [super dealloc];
}

-(void) drawContentView:(CGRect)r
{    
    static UIColor *titleColor;    
    titleColor = [UIColor darkTextColor];
    static UIColor *subTitleColor;    
    subTitleColor = [UIColor darkGrayColor];
    static UIColor *timeTitleColor;    
    timeTitleColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.7];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.highlighted || self.selected)
	{
		CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
		CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
		CGContextSetFillColorWithColor(context, titleColor.CGColor);					
	}
	else
	{
		CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
		CGContextSetFillColorWithColor(context, titleColor.CGColor);					
	}
    
    [titleColor set];
    [_thumbnail drawInRect:CGRectMake(12, 4, 35, 35)];
    [_title drawAtPoint:CGPointMake(54, 3) 
                    forWidth:200 
                    withFont:titleFont 
                    fontSize:17 
               lineBreakMode:UILineBreakModeTailTruncation 
          baselineAdjustment:UIBaselineAdjustmentAlignCenters];    

    [subTitleColor set];
    [_subTitle drawAtPoint:CGPointMake(54, 23) 
               forWidth:200 
               withFont:subTitleFont 
               fontSize:13 
          lineBreakMode:UILineBreakModeTailTruncation 
     baselineAdjustment:UIBaselineAdjustmentAlignCenters];    

    [timeTitleColor set];
    [_timeTitle drawAtPoint:CGPointMake(262, 3) 
                  forWidth:62 
                  withFont:timeTitleFont 
                  fontSize:10 
             lineBreakMode:UILineBreakModeTailTruncation 
        baselineAdjustment:UIBaselineAdjustmentAlignCenters];    

}

@end
