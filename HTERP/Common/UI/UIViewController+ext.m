//
//  UIViewController+ext.m
//  QQStock
//
//  Created by suning wang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "UIViewController+ext.h"
#import "CCustomUILabel.h"

#define kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN         13.0f
#define kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN        13.0f
#define kUIVIEWCONTROLLER_BUTTON_TOPMARGIN          5.0f
#define kUIVIEWCONTROLLER_BUTTON_BOTTOMMARGIN       5.0f

#define kUIVIEWCONTROLLER_LABEL_TAG                 10000

@implementation UIViewController (ext)

- (void) doRefreshView
{
}

- (void) doChangeTheme
{
}

- (void) selectedTabBarItemClicked
{
}

//- (UIImage*) imageWithStyle:(TCustomButtonStyle)buttonStyle size:(CGSize)imageSize
//{
//	NSString* l = nil;
//	NSString* c = nil;
//	NSString* r = nil;
//	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//	switch (buttonStyle)
//	{
//		case eCustomButtonSquareStyle:
//		{
//			l = @"black_l.png";
//			c = @"black.png";
//			r = @"black_r.png";
//		}
//			break;
//			
//		case eCustomButtonLeftAngleStyle:
//		{
//			l = @"backl.png";
//			c = @"black.png";
//			r = @"black_r.png";
//			edgeInsets.right = 5;
//		}
//			break;
//			
//		case eCustomButtonRedSquareStyle:
//		{
//			l = @"red_l.png";
//			c = @"red.png";
//			r = @"red_r.png";
//		}
//			break;
//			
//		default:
//			break;
//	}
//	return [CImageHelper getImage:imageSize l:l c:c r:r edgeInsets:edgeInsets];
//}
//
//- (UIButton*) buttonWithTitle:(NSString*)titleStr 
//					 fontSize:(float)fontSize 
//				   titleColor:(float)titleColor
//				  buttonStyle:(TCustomButtonStyle)buttonStyle
//{
//	NSAssert(titleStr != nil, @"title不能为空");
//	
//	UIFont* textFont = [UIFont systemFontOfSize:fontSize];
//	CGSize textSize = [titleStr sizeWithFont:textFont];
//	CGRect frame = CGRectMake(0, 0, kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN + textSize.width + kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN, kUIVIEWCONTROLLER_BUTTON_TOPMARGIN + textSize.height + kUIVIEWCONTROLLER_BUTTON_BOTTOMMARGIN);
//	
//	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//	button.frame = frame;
//	[button setTitle:titleStr forState:UIControlStateNormal];
//	[button setTitleColor:[UIColor colorWithWhite:titleColor/0xFFFFFF alpha:1.0f] forState:UIControlStateNormal];
//	button.titleLabel.font = textFont;
//	
//	UIImage* backgroundImage = [self imageWithStyle:buttonStyle size:frame.size];
//	NSAssert(backgroundImage != nil, @"逻辑错误");
//	[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//	return button;
//}

//更新title字符串，
- (void)updateCustomTitleText:(NSString*)text
{
    UILabel *titleLabel = (UILabel*)[self.navigationItem.titleView viewWithTag:kUIVIEWCONTROLLER_LABEL_TAG];
    
    if ( titleLabel )
    {
        titleLabel.text = text;
    }
}

//每次都addsubview是否不合理
- (void)setDisplayCustomTitleText:(NSString*)text
{
    NSString *title = @"";
    title = text;
    
    // Init views with rects with height and y pos
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    // Use autoresizing to restrict the bounds to the area that the titleview allows
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[CCustomUILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    titleLabel.tag = kUIVIEWCONTROLLER_LABEL_TAG;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FS_NavigationBar_Title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TC_CNavigationTitleColor;
    titleLabel.lineBreakMode = NSLineBreakByClipping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    //titleLabel.minimumFontSize = 8.f; //modify by zyz  原来13号字体,仍然有字体过大,导致的截断
    titleLabel.minimumScaleFactor = 8.0f/FS_NavigationBar_Title;
    titleLabel.text = title;
    
    //title实际尺寸
    CGSize textSize = [titleLabel.text sizeWithFont:titleLabel.font];
    
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    
    CGRect frame;
    
    CGFloat titleWidth = 0.f;
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    
    if ( maxWidth < 60 )//左右最少空隙50
    {
        maxWidth = 60;
    }
    maxWidth += 15;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
    titleWidth = ScreenWidth - maxWidth * 2;
    
    if ( textSize.width < titleWidth )//如果title实际宽度较小，使用实际宽度。
    {
        titleWidth = textSize.width;
    }
    
    frame = titleLabel.frame;
    frame.size.width = titleWidth;
    titleLabel.frame = frame;
    
    frame = titleView.frame;
    frame.size.width = titleWidth;
    titleView.frame = frame;
    
    // Add as the nav bar's titleview
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    
    
}

//自定义的titleview
- (void)setDisplayCustomTitleView:(UIView *)titleView
{
    self.navigationItem.titleView = titleView;
}

- (void)setDisplayCustomTitleImg:(UIImage *)img
{
    UIView* titleView = [[UIImageView alloc] initWithImage:img];
    self.navigationItem.titleView = titleView;
    
}
@end
