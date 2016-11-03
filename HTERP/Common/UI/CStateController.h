//
//  CPortfolioController.h
//  QQStock_lixiang
//
//  Created by xiang li on 13-10-11.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**状态控制器
 *
 */
@interface CStateController : NSObject
@property(nonatomic, assign) UIViewController *controller;

- (void)modifyLeftButtonItem:(id)leftButtonItem;
- (void)modifyRightButtonItem:(id)rightButtonItem;

- (void)modifyLeftButtonItem:(id)leftButtonItem animated:(BOOL)animated;
- (void)modifyRightButtonItem:(id)rightButtonItem animated:(BOOL)animated;
- (void)modifyLeftButtonItem:(id)leftButtonItem animated:(BOOL)animated delay:(NSTimeInterval)delay;
- (void)modifyRightButtonItem:(id)rightButtonItem animated:(BOOL)animated delay:(NSTimeInterval)delay;
- (void)showCustomTabBar;
- (void)hideCustomTabBar;
- (void)showCustomTabBarWithNoAnimation;
- (void)hideCustomTabBarWithNoAnimation;
@end
