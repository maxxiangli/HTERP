//
//  UIViewController+ext.h
//  QQStock
//
//  Created by suning wang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

enum 
{
	eCustomButtonLeftAngleStyle,
	eCustomButtonSquareStyle,
	eCustomButtonRedSquareStyle
};
typedef int TCustomButtonStyle;

@interface UIViewController (ext)

//当前ViewController对应的TabItem被点击后调用，如果是从其他tabitem切换到当前，
//不会调用该函数，之后在当前ViewController下点击tabItem才会调用它
- (void) selectedTabBarItemClicked;
- (void) doRefreshView;
- (void) doChangeTheme;
//- (UIButton*) buttonWithTitle:(NSString*)titleStr 
//					 fontSize:(float)fontSize 
//				   titleColor:(float)titleColor
//				  buttonStyle:(TCustomButtonStyle)buttonStyle;


//注意：在loadview的时候就要初始化好titleview的位置。在loadview之后调用setDisplayCustomTitleText，title会从屏幕的左边飞入，这个应该是系统的动画，不能截获。
//必须放在 leftBarButtonItem和rightBarButtonItem初始化之后调用
- (void)setDisplayCustomTitleText:(NSString*)text;

//自定义的titleview
- (void)setDisplayCustomTitleView:(UIView *)titleView;

//更新title字符串，(调用过setDisplayCustomTitleText之后，才能调用)
- (void)updateCustomTitleText:(NSString*)text;

- (void)setDisplayCustomTitleImg:(UIImage *)img;
@end
