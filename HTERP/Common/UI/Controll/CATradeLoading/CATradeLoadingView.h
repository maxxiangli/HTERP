//
//  CATradeLoadingView.h
//  QQStock
//
//  Created by michaelxing on 15/3/24.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATradeLoadingView : UIView
+ (CATradeLoadingView*)showLoadingViewAddedTo:(UIView *)view;
+ (BOOL)hideLoadingViewForView:(UIView *)view;
+ (NSUInteger)hideAllLoadingViewsForView:(UIView *)view;
+ (CATradeLoadingView*)LoadingViewForView:(UIView *)view;

- (void)startLoadingOnCurrentWindow;
- (void)startLoading:(UIView *)parentView;
- (void)stopLoading;

//修改默认位置
- (void)setUpLoadingViewCenter:(CGPoint)center;
//- (void)startLoading;
//- (void)removeLoading;
//
//- (void)setUpFrame:(CGRect)frame;
//- (void)setUpCircleFrame:(CGRect)frame;
//- (void)setUpImageViewFrame:(CGRect)frame;
- (void)setUpLoadingBackGroundColor:(UIColor *)color;
@end
