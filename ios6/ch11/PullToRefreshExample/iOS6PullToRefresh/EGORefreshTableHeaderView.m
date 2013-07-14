//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "EGORefreshTableHeaderView.h"


@implementation EGORefreshTableHeaderView

@synthesize state=_state;

static NSDateFormatter *refreshFormatter;


+ (void)initialize
{
  /* Formatter for last refresh date */
  refreshFormatter = [[NSDateFormatter alloc] init];
  [refreshFormatter setDateStyle:NSDateFormatterShortStyle];
  [refreshFormatter setTimeStyle:NSDateFormatterShortStyle];
}

//=========================================================== 
//  keyNameForDataStore 
//=========================================================== 
- (NSString *)keyNameForDataStore
{
    return _keyNameForDataStore; 
}
- (void)setKeyNameForDataStore:(NSString *)theKeyNameForDataStore
{
    if (_keyNameForDataStore != theKeyNameForDataStore) {

        _keyNameForDataStore = [theKeyNameForDataStore copy];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:_keyNameForDataStore]) {
			lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:_keyNameForDataStore];
		} else {
			[self setCurrentDate];
		}
    }
}

// Sets up the frame following the recipe in the samples except it doesn't *overlap* the partner view,
// ensuring that if you choose to draw a bottom border (by setting bottomBorderThickness > 0.0) then
// you'll get a proper border, not a partially obscured one.
- (id)initWithFrameRelativeToFrame:(CGRect)originalFrame {
	CGRect relativeFrame = CGRectMake(0.0f, 0.0f - originalFrame.size.height, originalFrame.size.width, originalFrame.size.height);
	return [self initWithFrame:relativeFrame];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 25.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.5f];
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:lastUpdatedLabel];

		
		self.backgroundColor = [UIColor colorWithWhite:0.55 alpha:1.0];
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 45.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
		statusLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.5f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = NSTextAlignmentCenter;
		[self setState:EGOOPullRefreshNormal];
		[self addSubview:statusLabel];
        
		
		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(28.0f, frame.size.height - 60.0f, 23.0f, 60.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id)[UIImage imageNamed:@"RefreshArrow.png"].CGImage;
		[[self layer] addSublayer:arrowImage];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(28.0f, frame.size.height - 40.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
    }
    return self;
}

- (void)setLastRefreshDate:(NSDate*)date
{
  if (!date) {
    [lastUpdatedLabel setText:NSLocalizedString(@"Never Updated", @"No Last Update Date text")];
    return;
  }
  
	lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [refreshFormatter stringFromDate:date]];
}

- (void)setCurrentDate {
	lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [refreshFormatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:[self keyNameForDataStore]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			statusLabel.text = NSLocalizedString(@"Release to update…",@"");
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:.18];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			statusLabel.text = NSLocalizedString(@"Pull down to update…",@"");
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = NO;
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshLoading:
			
			statusLabel.text = NSLocalizedString(@"Loading…",@"");
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshUpToDate:
        
			statusLabel.text = NSLocalizedString(@"Up-to-date.",@"");
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)dealloc {
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
}


@end
