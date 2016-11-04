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


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


#define TEXT1_COLOR     [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]
#define TEXT2_COLOR     [UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0]


@interface EGORefreshTableHeaderView ()
@property (nonatomic, strong) NSString *updateStr;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        [formatter setDateFormat:@"MM/dd HH:mm:ss"];
        self.dateFormatter = formatter;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = TC_RefreshBackgroundColor;
		_updateStr = [[NSString alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 36.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:14.0f];
		label.textColor = TC_RefreshTitleColor;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
        CGFloat maxLabelWidth = [@"释放刷新 最后刷新 MM/dd HH:mm:ss" sizeWithFont:_statusLabel.font].width;
		layer.frame = CGRectMake((ScreenWidth - maxLabelWidth) / 2 - 11 - 5, frame.size.height - 33.5f, 11.0f, 18.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)BUNDLEIMAGE(@"RefreshArrow.png").CGImage;
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
        [[self layer] addSublayer:layer];
		_arrowImage=layer;
        [self changeDisplayTheme];
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
}

-(void) changeDisplayTheme
{
	CGFloat theWidth = CGRectGetWidth(self.bounds);
    self.backgroundColor = TC_RefreshBackgroundColor;
    _statusLabel.textColor = TC_RefreshTitleColor;
	_arrowImage.contents = (id)BUNDLEIMAGE(@"RefreshArrow.png").CGImage;
	
    if (_activityView)
    {
        [_activityView removeFromSuperview];
    }
    
    UIActivityIndicatorView *view = nil;
	view = [[UIActivityIndicatorView alloc] init];
	view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	view.color = THEMECOLOR(@"UIPullHeaderLoadingColor");
    
    CGFloat maxLabelWidth = [@"释放刷新 最后刷新 MM/dd HH:mm:ss" sizeWithFont:_statusLabel.font].width;
    view.frame = CGRectMake((theWidth - maxLabelWidth) / 2 - 20 - 5, self.bounds.size.height - 36.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    
}

-(void)layoutSubviews{
    CGFloat maxLabelWidth = [@"释放刷新 最后刷新 MM/dd HH:mm:ss" sizeWithFont:_statusLabel.font].width;
    _arrowImage.frame = CGRectMake((self.bounds.size.width - maxLabelWidth) / 2 - 11 - 5, self.bounds.size.height - 33.5f, 11.0f, 18.0f);
    _activityView.frame = CGRectMake((self.bounds.size.width - maxLabelWidth) / 2 - 20 - 5, self.bounds.size.height - 36.0f, 20.0f, 20.0f);
}


#pragma mark -
#pragma mark Setters

- (EGOPullRefreshState)getPullingState
{
    return _state;
}

- (void)refreshLastUpdatedDate {
    
    NSString *tips = nil;

    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		tips = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
    }
    else
    {
        //modify by maxxiangli for bug id 49918384 on 20141112
        tips = [NSString stringWithFormat:@"最后更新 %@", [self.dateFormatter stringFromDate:[NSDate date]]];
    }
	[self setUpdateStr:tips];
}

- (void)setState:(EGOPullRefreshState)aState{
	switch (aState) {
		case EGOOPullRefreshPulling:
		{
			NSString *pullUpdateStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"释放刷新", @"Release to refresh status"), _updateStr];
			_statusLabel.text = pullUpdateStr;
            
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
		}
			
			break;
		case EGOOPullRefreshNormal:
		{
			NSString *pullUpdateStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"释放刷新", @"Release to refresh status"), _updateStr];
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = pullUpdateStr;
			
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
		}
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"更新中...", @"Loading Status");

			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
    
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset + _contentInsert, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
		
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && (scrollView.contentOffset.y + _contentInsert) > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && (scrollView.contentOffset.y + _contentInsert) < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsMake(_contentInsert,scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y + _contentInsert <= - 65.0f && !_loading) {
        
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
        
        [self setState:EGOOPullRefreshLoading];

        //modify by maxxiangli on 2015.02.10 for 解决弹簧效果和inset时序冲突导致的下拉刷新抖动问题。
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                UIEdgeInsets inset = UIEdgeInsetsMake(60.0f + _contentInsert, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                scrollView.contentInset = inset;
                [scrollView setContentOffset:CGPointMake(0, -inset.top) animated:NO];
            } completion:^(BOOL finished) {
            }];
        });
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f + _contentInsert, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}

- (void)egoEnforceLoading:(UIScrollView *)scrollView 
{
    BOOL _loading = NO;
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }

    if (!_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentOffset = CGPointMake(0, -60 + _contentInsert);
        scrollView.contentInset = UIEdgeInsetsMake(60.0f + _contentInsert, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
        [UIView commitAnimations];
    }
}

- (void)egoEnforceLoading:(UIScrollView *)scrollView animated:(BOOL)animated
{
    BOOL _loading = NO;
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (!_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];

        scrollView.contentOffset = CGPointMake(0, -60 + _contentInsert);
        scrollView.contentInset = UIEdgeInsetsMake(60.0f + _contentInsert, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
    }
}
@end
