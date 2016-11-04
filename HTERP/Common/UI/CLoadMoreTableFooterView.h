//
//  CLoadMoreTableFooterView.h
//  QQStock
//
//  Created by zheliang on 15/4/1.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LoadMorePulling = 0,
    LoadMoreNormal,
    LoadMoreLoading,
} LoadMoreState;

@protocol CLoadMoreTableFooterDelegate;
@interface CLoadMoreTableFooterView : UIView {
    LoadMoreState _state;
    
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,weak) id <CLoadMoreTableFooterDelegate> delegate;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setActivityColor:(UIColor *)color;

@end

@protocol CLoadMoreTableFooterDelegate<NSObject>
- (void)loadMoreTableFooterDidTriggerRefresh:(CLoadMoreTableFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(CLoadMoreTableFooterView *)view;
@end