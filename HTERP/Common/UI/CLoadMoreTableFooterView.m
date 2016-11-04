//
//  CLoadMoreTableFooterView.m
//  QQStock
//
//  Created by zheliang on 15/4/1.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CLoadMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface CLoadMoreTableFooterView (Private)

- (void)setState:(LoadMoreState)aState;

@end

@interface CLoadMoreTableFooterView ()
{
    BOOL _isScrollwithChangeInset;
}
@end
@implementation CLoadMoreTableFooterView



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, ScreenWidth, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = TC_RefreshTitleColor;
        //	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        view.frame = CGRectMake((self.width - 20.f) / 2.0, 20.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        self.hidden = YES;
        _isScrollwithChangeInset = NO;
        [self setState:LoadMoreNormal];
    }
    
    return self;
}

- (void)setActivityColor:(UIColor *)color
{
    if (_activityView) {
        [_activityView setColor:color];
    }
}
#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{
    switch (aState) {
        case LoadMorePulling:
            _statusLabel.text = NSLocalizedString(@"释放查看更多...", @"Release to load more");
            break;
        case LoadMoreNormal:
            _statusLabel.text = NSLocalizedString(@"上拉查看更多...", @"Load More");
            _statusLabel.hidden = NO;
            [_activityView stopAnimating];
            break;
        case LoadMoreLoading:
            _statusLabel.hidden = YES;
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isScrollwithChangeInset) {
        _isScrollwithChangeInset = NO;
        return;
    }
    if (_state == LoadMoreLoading) {
        _isScrollwithChangeInset = YES;

        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        
        if (_state == LoadMoreNormal && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.bounds.size.height +  65) && scrollView.contentOffset.y > 0.0f && !_loading) {
            self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
            self.hidden = NO;
        } else if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.size.height +  65)  && !_loading) {
            [self setState:LoadMorePulling];
        } else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.bounds.size.height +  65) && scrollView.contentOffset.y > 0.0f && !_loading) {
            [self setState:LoadMoreNormal];
        }
        
        if (scrollView.contentInset.bottom != 0) {
            _isScrollwithChangeInset = YES;

            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.size.height +  65) && !_loading) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
        
        [self setState:LoadMoreLoading];
        _isScrollwithChangeInset = YES;
        [UIView animateWithDuration:0.2     animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
            
        }];
    }
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    _isScrollwithChangeInset = YES;

//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsZero];
//    [UIView commitAnimations];
    [self setState:LoadMoreNormal];
    self.hidden = YES;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    
}




@end
