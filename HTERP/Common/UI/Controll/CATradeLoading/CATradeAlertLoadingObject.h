//
//  CATradeAlertLoadingView.h
//  QQStock
//
//  Created by michaelxing on 15/5/13.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATradeAlertLoadingObject : NSObject

- (void)show;
- (void)hidden;

- (void)showOnView:(UIView *)view;
- (void)showOnCurrentWindow;

- (void)setUpLoadingViewCenter:(CGPoint)center;

- (void)setBackgroundColor:(UIColor *)color;

@end
