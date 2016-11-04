//
//  UINavigationBar+Draw.m
//  QQStock
//
//  Created by suning wang on 11-11-5.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import "UINavigationBar+Draw.h"

@implementation UINavigationBar (Draw)

static UIColor* _backgroundColor = nil;
+ (UIColor*) customBackgroundColor
{
	return _backgroundColor == nil ? [UIColor blackColor] : _backgroundColor;
}

static UIImage* _backgroundImage = nil;
+ (UIImage*) customBackgroundImage
{
	return _backgroundImage;
}

+(void) navigationBarEnhancement
{
#if iOS7SDK
	if ((isThaniOS6)) {
		[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//		[[UINavigationBar appearance] setTranslucent:NO];
	}
#endif
}

+ (void) setCustomBackgroundColor:(UIColor*)color
{
	
	_backgroundColor = color;
	if (_backgroundColor == nil)
	{
		_backgroundColor = [UIColor blackColor];
	}
	
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 5.0)
	{
		[[UINavigationBar appearance] setBackgroundImage:[CImageHelper getImage:CGSizeMake(5, 5) withColor:[UINavigationBar customBackgroundColor]] 
										   forBarMetrics:UIBarMetricsDefault];
	}
}

+ (void) setCustomBackgroundImage:(UIImage*)backgroundImage
{
	
	_backgroundImage = backgroundImage;
	
	if (backgroundImage != nil && [[UIDevice currentDevice].systemVersion doubleValue] >= 5.0)
	{
#if iOS7SDK
		if ((isThaniOS6)) {
			[[UINavigationBar appearance] setBackgroundImage:backgroundImage
											  forBarPosition:UIBarPositionTop
												  barMetrics:UIBarMetricsDefault];

//!!!!!!  在ios9 下 ,会出问题.返回按键颜色变灰,所以注释掉以下代码. 复现步骤:1,重新安装 2,在引导页点击登录股票圈 3,然后随便进入下一级.
//		[[UINavigationBar appearance] setTintColor:TC_NavigationBarTintColor];



		} else
#endif
		{
			[[UINavigationBar appearance] setBackgroundImage:backgroundImage
											   forBarMetrics:UIBarMetricsDefault];
			if (isiOS6) {
				[[UINavigationBar appearance] setShadowImage:BUNDLEIMAGE(@"shadowImage.png")];
			}
			//此处代码是为了更改分享短信、邮件时使用到系统controller顶部按钮颜色
			//IO4.3 无法使用该方法
			if (eThemeBlueWhite == [CConfiguration sharedConfiguration].themeType)
			{
				[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.1 green:0.35 blue:0.5 alpha:1]];
			}
			else
			{
				[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
			}
		}
		
	}
}

//- (void)addSubview:(UIView *)view
//{
//    //此处代码是为了更改分享短信、邮件时使用到系统controller顶部按钮颜色
//    //IOS6.0 使用该方法在第二层不起作用
//    if(nil == self.tintColor)
//    {
//        if (eThemeBlueWhite == [CConfiguration sharedConfiguration].themeType)
//        {
//            [self setTintColor:[UIColor colorWithRed:0.1 green:0.35 blue:0.5 alpha:1]];
//        }
//        else
//        {
//            [self setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
//        }
//    }
//    
//    [super addSubview:view];
//}
//
//- (void) drawRect:(CGRect)rect
//{
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	UIImage* backgroundImage = [UINavigationBar customBackgroundImage];
//	if (backgroundImage != nil)
//	{
//		[backgroundImage drawInRect:self.bounds];
//	}
//	else 
//	{
//		UIColor* backgroundColor = [UINavigationBar customBackgroundColor];
//		[backgroundColor set];
//		CGContextFillRect(ctx, self.bounds);
//	}
//}

+ (void) setNeedsLayoutDeep:(UIView*)view
{
//	if ([view isKindOfClass:[UINavigationBar class]] && ![[UIApplication sharedApplication] isStatusBarHidden])
//	{
//		CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
//		CGRect frame = view.frame;
//		frame.origin.x = 0;
//		frame.origin.y = screenFrame.origin.y;
//		frame.size.width = screenFrame.size.width;
//		frame.size.height = kNavigationBarHeight;
//		view.frame = frame;
//	}
	[view setNeedsLayout];
	
	NSArray* subViews = [view subviews];
	if (subViews != nil)
	{
		for (UIView* v in subViews)
		{
			[self setNeedsLayoutDeep:v];
		}
	}
}

@end

