//
//  CNewNavigationController.m
//  QQStock
//
//  Created by kenna on 8/15/13.
//  Copyright (c) 2013 tencent. All rights reserved.
//

#import "CNavigationController.h"
#import "CCustomViewController.h"
#import "AppDelegate.h"
//#import <QuartzCore/QuartzCore.h>

//#define TABBAR_MASK_VIEW_TAG	0x1024

@interface CNavigationController()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
{
	CGPoint startedPoint;
	UIImageView *lastScreenShotView;
	UIView *blackMask;
	BOOL isMoving, canBack;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShots;
@property (nonatomic, assign) UIViewController *lastViewController;
@end

@implementation CNavigationBar

#define CNAVIGATIONBAR_BUTTON_MARGIN			15
#define CNAVIGATIONBAR_BUTTON_MARGIN_IOS7		8
#define CNAVIGATIONBAR_BUTTON_MARGIN_IOS7_HACK	15

#define CNAVIGATIONBAR_RIGHT_BUTTON_OFFSET		9


#define kCustomTabBarDefaultHeight SZ_CustomTabBar_Height

-(void) layoutSubviews {
	[super layoutSubviews];
	if (!(isThaniOS6)) {
		if (self.topItem) {
			if (self.topItem.leftBarButtonItem && self.topItem.leftBarButtonItem.customView) {
				CGRect r = self.topItem.leftBarButtonItem.customView.frame;
				r.origin.x = CNAVIGATIONBAR_BUTTON_MARGIN;
				self.topItem.leftBarButtonItem.customView.frame = r;
			}
			if (self.topItem.rightBarButtonItem && self.topItem.rightBarButtonItem.customView) {
				CGRect r = self.topItem.rightBarButtonItem.customView.frame;
				r.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(r) - (CNAVIGATIONBAR_BUTTON_MARGIN - CNAVIGATIONBAR_RIGHT_BUTTON_OFFSET);
				self.topItem.rightBarButtonItem.customView.frame = r;
			}
			[self setNeedsDisplay];
		}
	} else {
		if (self.topItem) {
			int buttonMargin = CNAVIGATIONBAR_BUTTON_MARGIN_IOS7;
			/////////////////////////////////////////////////////////////////////////////
			// 一个Hack 方法, 设置左右按钮的边距为15.
			for (UIView *childView in self.subviews) {
				if ([@"_UINavigationBarBackIndicatorView" isEqualToString:NSStringFromClass([childView class])]) {
					CGRect r		= childView.frame;
					r.origin.x		= CNAVIGATIONBAR_BUTTON_MARGIN_IOS7_HACK;
					childView.frame	= r;
					buttonMargin	= CNAVIGATIONBAR_BUTTON_MARGIN_IOS7_HACK;
				}
			}
			/////////////////////////////////////////////////////////////////////////////
			
//			if (self.topItem.backBarButtonItem && self.topItem.backBarButtonItem.customView) {
//				self.topItem.backBarButtonItem.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)] ;
//				CGRect r = self.topItem.backBarButtonItem.customView.frame;
//				r.origin.x = CNAVIGATIONBAR_BUTTON_MARGIN;
//				self.topItem.backBarButtonItem.customView.frame = r;
//			}
			if (self.topItem.leftBarButtonItem && self.topItem.leftBarButtonItem.customView) {
				CGRect r = self.topItem.leftBarButtonItem.customView.frame;
				r.origin.x = buttonMargin;
				self.topItem.leftBarButtonItem.customView.frame = r;
			}
			if (self.topItem.rightBarButtonItem && self.topItem.rightBarButtonItem.customView) {
				CGRect r = self.topItem.rightBarButtonItem.customView.frame;
				r.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(r) - (buttonMargin - CNAVIGATIONBAR_RIGHT_BUTTON_OFFSET);
				self.topItem.rightBarButtonItem.customView.frame = r;
			}
			[self setNeedsDisplay];
		}
	}
}

- (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	[color setFill];
	UIRectFill(rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

-(void) updateNavigationWithColor:(UIColor *)color {
	UIImage *image = [self imageWithColor:color];
	[self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	[self setBarStyle:UIBarStyleDefault];
	[self setShadowImage:[UIImage new] ];
//	[self setTitleTextAttributes:@{NSForegroundColorAttributeName: TC_NavigationBarTintColor }];
//	[self setTintColor: TC_NavigationBarTintColor ];
////	[self setTranslucent:YES];
}

-(void) updateNavigationWithDefaultColor {
	[self setBackgroundImage:BUNDLEIMAGE((isThaniOS6)?@"stock_navi_bg_128.png":@"stock_navi_bg.png")
			   forBarMetrics:UIBarMetricsDefault];
	[self setTintColor:TC_NavigationBarTintColor];
	[self setAlpha:1.f];
	[self setTranslucent:NO];
}

-(void) tranparentNavigationBar {
	[self updateNavigationWithColor:[UIColor clearColor]];
	[self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor] }];
	[self setTintColor: [UIColor clearColor] ];
//	[self setAlpha:0.f];
	[self setTranslucent:YES];
}

@end

@interface CNavigationController()<UINavigationBarDelegate>
@property (nonatomic,retain) NSString * lastPushClass;
@property (nonatomic,retain) NSDate * lastPushDate;
@end

@implementation CNavigationController
@synthesize allowDragBack = canBack;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if(( self = [super initWithNavigationBarClass:[CNavigationBar class] toolbarClass: [UIToolbar class]]))
	{
        self.lastPushDate = nil;
        self.lastPushClass = nil;
//	if ((self = [super initWithRootViewController:rootViewController])) {
		[self setViewControllers:@[rootViewController] animated:NO];
		self.screenShots = [[NSMutableArray alloc] initWithCapacity:2] ;
		canBack = YES;
		self.delegate = self;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
#if iOS7SDK
	if ((isThaniOS6)) {
//		if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//		{
//			self.interactivePopGestureRecognizer.delegate = self;
//		}
		[self.interactivePopGestureRecognizer addTarget:self action:@selector(handleNavigationTransition:)];
	}
	else
#endif
	{
		UIImageView *shadowView = [[UIImageView alloc] initWithImage:BUNDLEIMAGE(@"stockdetail_left_shadow.png")] ;
		[shadowView setFrame:CGRectMake(-8, 0, 8, self.view.frame.size.height)];
		[self.view addSubview:shadowView];
		UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
																					  action:@selector(paningGestureReceive:)];
		recognizer.delegate = self;
		[recognizer delaysTouchesBegan];
		[self.view addGestureRecognizer:recognizer];
	}
	
/////////////////////////////////////////////////////////////////////////////
// 一个Hack 方法, 隐藏Navigation Bar 下面的线.
// iOS 6 & 7 通用.
//	for (UIView *childView in self.navigationBar.subviews) {
//		for (UIView *theView in childView.subviews) {
//			if ([theView isKindOfClass:[UIImageView class]]) {
////				[theView removeFromSuperview];
//				[theView setHidden:YES];
//			}
//		}
//	}
/////////////////////////////////////////////////////////////////////////////
}

- (void) setAllowDragBack:(BOOL) val {
	canBack = val;
#if iOS7SDK
		if ((isThaniOS6)) {
			self.interactivePopGestureRecognizer.enabled = val;
		}
#endif
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	return canBack;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //这段代码是为了解决iphone4 ios7环境下，按钮总是响应两次点击事件，导致push两次
    if(self.lastPushDate)
    {
        if([[NSDate date] timeIntervalSinceDate:self.lastPushDate] < 1.0)
        {
            //1秒之内，相同类型的controller不允许push两次
            NSString * className = [NSString stringWithUTF8String:object_getClassName(viewController)];
            if([className isEqualToString:self.lastPushClass])
            {
                return;
            }
        }
    }
    
    self.lastPushDate = [NSDate date];
    self.lastPushClass = [NSString stringWithUTF8String:object_getClassName(viewController)];
    
	self.lastViewController = self.visibleViewController;
//#if iOS7SDK
//	if ((isThaniOS6)) {
//		UIViewController *topViewController = self.visibleViewController;
//
//		BOOL isShowDummyTabbar = allowAutorotate && isScreenLandscape;
//		if (topViewController && [topViewController isKindOfClass:[CCustomViewController class]]) {
//			//TODO: 解决在右滑返回时, Tabbar 区别变黑的问题.
//			//先解决问题, 再想办法优化.
//			if (topViewController.customTabBarController && !topViewController.customTabBarController.isHidden) {
//				CGRect r = [UIScreen mainScreen].bounds;
//				CGRect v = CGRectMake(CGRectGetMinX(r), CGRectGetHeight(r) - [CCustomTabBarController height] , CGRectGetWidth(r), [CCustomTabBarController height]);
////				UIImage *theScreenShot = /*BUNDLEIMAGE_C(@"tabbar_snapshot.png");*/
////				[self cropImageWithRect:v originalImage:[self captureScreenShot]];
//				UIImage *theScreenShot = [self captureTabbarShot];
//				if (theScreenShot) {
//					UIImageView *maskView =	[[UIImageView alloc] initWithImage:theScreenShot] ;
//					maskView.frame	= CGRectMake(CGRectGetMinX(v), CGRectGetMinY(v) - CGRectGetMinY(topViewController.view.frame), CGRectGetWidth(v), CGRectGetHeight(v));
//					//CGRectMake(0, -64, r.size.width, r.size.height);
//					maskView.tag	= TABBAR_MASK_VIEW_TAG;
//					maskView.hidden = isShowDummyTabbar;
//					[topViewController.view addSubview:maskView];
//				}
//			}
//		}
//	} else
//#endif
//	{
////		lastViewController = self.visibleViewController;
//		UIImage *theScreenShot = [self captureScreenShot];
//		if (theScreenShot) {
//			[self.screenShots addObject:theScreenShot];
//		}
//	}
	[super pushViewController:viewController animated:animated];
}

-(UIImage*) cropImageWithRect:(CGRect) rect originalImage:(UIImage*) image {
	if (!image) return nil;
	
	int scale	= [UIScreen mainScreen].scale;
	CGRect r	= CGRectMake(CGRectGetMinX(rect) * scale,
							 CGRectGetMinY(rect) * scale,
							 CGRectGetWidth(rect) * scale,
							 CGRectGetHeight(rect) * scale);
	
	CGImageRef cgImage	= CGImageCreateWithImageInRect([image CGImage], r);
	UIImage *newImage	= [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	return  newImage;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
//	if ((isThaniOS6)) {
		self.lastViewController = self.visibleViewController;
//	}
	return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
#if iOS7SDK
	if ((isThaniOS6)) {
//		if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//		{
//			self.interactivePopGestureRecognizer.delegate = self;
//		}
	} else
#endif
	{
		[self clearWhenPopController];
		[self.screenShots removeLastObject];
	}
//	if ((isThaniOS6)) {
		self.lastViewController = self.visibleViewController;
//	}
	return [super popViewControllerAnimated:animated];
}

- (NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
#if iOS7SDK
	if ((isThaniOS6)) {
		//		if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
		//		{
		//			self.interactivePopGestureRecognizer.delegate = self;
		//		}
	} else
#endif
	{
		[self clearWhenPopController];
		NSUInteger dst_pos = [self.viewControllers indexOfObject:viewController];
		if(dst_pos != NSNotFound){
			NSUInteger remove_count = [self.viewControllers count] - dst_pos - 1;
			while(remove_count--){
				[self.screenShots removeLastObject];
			}
		}
	}
//	if ((isThaniOS6)) {
		self.lastViewController = self.visibleViewController;
//	}
	
	return [super popToViewController:viewController animated:animated];
}

- (void) updateNavigationBarTranparent {
	UIViewController *topViewController = self.topViewController;
	if ([topViewController isKindOfClass:[CCustomViewController class]]) {
		CCustomViewController *v = (CCustomViewController*) topViewController;
		CNavigationBar *bar = (CNavigationBar*) self.navigationBar;
		if (v.isNavigationBarTranparent) {
			[bar tranparentNavigationBar];
		} else {
			[bar updateNavigationWithDefaultColor];
		}
	}

}

- (void) handleNavigationTransition:(UIPanGestureRecognizer *)recoginzer {
	CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
	CGPoint xx = [recoginzer velocityInView:[[UIApplication sharedApplication] keyWindow]];
	//	if (self.viewControllers.count <= 1 || !canBack) return;
	NSInteger screenWidth = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
	CGFloat leftOffsetPercent =  touchPoint.x / screenWidth;
	
	CNavigationBar *bar = (CNavigationBar*) self.navigationBar;
	if (recoginzer.state == UIGestureRecognizerStateBegan) {
//		NSLog(@"########################################        UIGestureRecognizerStateBegan  ");
		UIViewController *topViewController = self.visibleViewController;
		if ([topViewController isKindOfClass:[CCustomViewController class]]) {
			CCustomViewController *v = (CCustomViewController*) topViewController;
			BOOL isTranparent = v.isNavigationBarTranparent;
			if (isTranparent) {
				bar.translucent = YES;
				isMoving = YES;
			}
		}
	}else if (recoginzer.state == UIGestureRecognizerStateEnded){
//		NSLog(@"----------------------- *  %f", leftOffsetPercent);
//		NSLog(@"########################################        UIGestureRecognizerStateEnded  ");
		UIViewController *topViewController = self.visibleViewController;
		if (leftOffsetPercent > 0.55 || xx.x > 400.f) {
//			NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     >   .55 (%f) -->  %@ ", leftOffsetPercent, NSStringFromCGPoint(xx));
			
			if ([topViewController isKindOfClass:[CCustomViewController class]]) {
				CCustomViewController *v = (CCustomViewController*) topViewController;
				if (v.isNavigationBarTranparent) {
					[bar tranparentNavigationBar];
				} else {
					[bar updateNavigationWithDefaultColor];
				}
			}
		} else  {
//			NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$      <  .55 (%f) -->  %@ ", leftOffsetPercent, NSStringFromCGPoint(xx));
			if (_lastViewController && [_lastViewController isKindOfClass:[CCustomViewController class]]) {
				CCustomViewController *v = (CCustomViewController*) _lastViewController;
				if (v.isNavigationBarTranparent) {
					[bar tranparentNavigationBar];
				} else {
					[bar updateNavigationWithDefaultColor];
				}
			}
		}
		isMoving = NO;
		return;
	}else if (recoginzer.state == UIGestureRecognizerStateCancelled){
//		NSLog(@"----------------------- *  %f", leftOffsetPercent);
//		NSLog(@"########################################        UIGestureRecognizerStateCancelled  ");
		UIViewController *topViewController = self.visibleViewController;
		
		if ([topViewController isKindOfClass:[CCustomViewController class]]) {
			CCustomViewController *v = (CCustomViewController*) topViewController;
			if (v.isNavigationBarTranparent) {
				[bar tranparentNavigationBar];
			} else {
				[bar updateNavigationWithDefaultColor];
			}
		}
		isMoving = NO;
		return;
	}
	
	if (isMoving) {
		CGFloat alphaValue = 1.f - leftOffsetPercent;
		UIViewController *topViewController = self.visibleViewController;
		if ([topViewController isKindOfClass:[CCustomViewController class]]) {
			bar.alpha = alphaValue;
		}
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//	if (isThaniOS6 ) {
		if ([viewController isKindOfClass:[CCustomViewController class]]) {
			CCustomViewController *v = (CCustomViewController*) viewController;
			CNavigationBar *bar = (CNavigationBar*) self.navigationBar;
			if (v.isNavigationBarTranparent) {
				bar.alpha = 0.99f;
				bar.translucent = YES;
				if (!isMoving) {
					[bar tranparentNavigationBar];
				}
			} else  {
				[bar updateNavigationWithDefaultColor];
			}
		}
//	}
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//	if (isThaniOS6 ) {
		if ([viewController isKindOfClass:[CCustomViewController class]]) {
			CCustomViewController *v = (CCustomViewController*) viewController;
			CNavigationBar *bar = (CNavigationBar*) self.navigationBar;
			if (v.isNavigationBarTranparent) {
				[bar tranparentNavigationBar];
			} else {
				[bar updateNavigationWithDefaultColor];
			}
		}
		isMoving = NO;
//	}
	self.lastViewController = nil;

//	UIView *theView = viewController.view;
//	UIImageView *theMaskview = (UIImageView*)[theView viewWithTag:TABBAR_MASK_VIEW_TAG];
//	if (theMaskview) {
//		[theMaskview removeFromSuperview];
//	}
}


- (void) clearWhenPopController
{
	_lastViewController = nil;
	
	[lastScreenShotView removeFromSuperview];
	lastScreenShotView = nil;
	
	[blackMask removeFromSuperview];
	blackMask = nil;
	
	
	_backgroundView = nil;
}

- (UIImage *)captureScreenShot
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	UIWindow *theKeyWindow = nil;
	if ((windows.count > 1) || ![UIApplication sharedApplication].keyWindow) {
		for (UIWindow *theWindow in windows) {
			if ([theWindow isMemberOfClass:[UIWindow class]]) {
				theKeyWindow = theWindow;
			}
		}
	} else {
		theKeyWindow = [[UIApplication sharedApplication] keyWindow];
	}
	
//	UIWindow *theKeyWindow = [[UIApplication sharedApplication] keyWindow];
	if (!theKeyWindow) return nil;
	@try {
		UIGraphicsBeginImageContextWithOptions(theKeyWindow.bounds.size, theKeyWindow.opaque, 0.0);
		[theKeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return img;
	}
	@catch (NSException *exception) {
		return nil;
	}
}

- (UIImage *)captureTabbarShot
{
//	@try {
//		return [SharedAPPDelegate.tabBarController captureView];
//	} @catch (NSException *exception) {
//		return nil;
//	}
    
    return nil;
}

- (UIImage *)captureScreenShotWithView:(UIView*) theView
{
	if (!theView) return nil;
	@try {
		UIGraphicsBeginImageContextWithOptions(theView.bounds.size, theView.opaque, 0.0);
		[theView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return img;
	}
	@catch (NSException *exception) {
		return nil;
	}
}

- (void)viewMoveAanimationWithPoint:(float) pointX
{
//	UIWindow *theKeyWindow = [[UIApplication sharedApplication] keyWindow];
	
	NSArray *windows = [[UIApplication sharedApplication] windows];
	UIWindow *theKeyWindow = nil;
	if ((windows.count > 1) || ![UIApplication sharedApplication].keyWindow) {
		for (UIWindow *theWindow in windows) {
			if ([theWindow isMemberOfClass:[UIWindow class]]) {
				theKeyWindow = theWindow;
			}
		}
	} else {
		theKeyWindow = [[UIApplication sharedApplication] keyWindow];
	}
	
	//	UIWindow *theKeyWindow = [[UIApplication sharedApplication] keyWindow];
	if (!theKeyWindow) return;
	
	pointX = pointX > theKeyWindow.frame.size.width?theKeyWindow.frame.size.width:pointX;
	pointX = pointX < 0 ? 0 : pointX;
	
	CGRect frame = self.view.frame;
	frame.origin.x = pointX;
	self.view.frame = frame;
	
//    float scale = (pointX/6400) + 0.95;  //缩放步进.
//    float alpha = 0.8 - (pointX / 400); //Alpha 步进.
	
	float width = theKeyWindow.frame.size.width;

	float x =  (pointX * .3) - (width * .3 );
	
	[lastScreenShotView setTransform:CGAffineTransformMakeTranslation(x, 0)];
	
//	[lastScreenShotView setTransform:CGAffineTransformMakeScale(scale, scale)];
	[blackMask setAlpha:0];
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
	if (self.viewControllers.count <= 1 || !canBack) return;
	
	CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
	
	if (recoginzer.state == UIGestureRecognizerStateBegan) {
		isMoving = YES;
		startedPoint = touchPoint;
		
		if (!self.backgroundView)
		{
			CGRect frame = self.view.frame;
			self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)] ;
			[self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
			blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)] ;
			blackMask.backgroundColor = [UIColor blackColor];
			[self.backgroundView addSubview:blackMask];
		}
		
		self.backgroundView.hidden = NO;
		if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
		UIImage *lastScreenShot = [self.screenShots lastObject];
		if (!lastScreenShot) {
			lastScreenShot = [self captureScreenShot];
		}
		lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot] ;
		[self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
		
	}else if (recoginzer.state == UIGestureRecognizerStateEnded){
		int screenWidth = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
		
		if (touchPoint.x - startedPoint.x > (screenWidth*.4))
		{
			[UIView animateWithDuration:0.3 animations:^{
				[self viewMoveAanimationWithPoint:screenWidth];
			} completion:^(BOOL finished) {
				[self popViewControllerAnimated:NO];
				CGRect frame = self.view.frame;
				frame.origin.x = 0;
				self.view.frame = frame;
				isMoving = NO;
				
				[CBossReporter reportTickInfo:eRepTypeNavigationDragBack];
				
			}];
		}
		else
		{
			[UIView animateWithDuration:0.3 animations:^{
				[self viewMoveAanimationWithPoint:0];
			} completion:^(BOOL finished) {
				isMoving = NO;
				self.backgroundView.hidden = YES;
			}];
			
		}
		return;
		
		// cancal panning, alway move to left side automatically
	}else if (recoginzer.state == UIGestureRecognizerStateCancelled){
		[UIView animateWithDuration:0.3 animations:^{
			[self viewMoveAanimationWithPoint:0];
		} completion:^(BOOL finished) {
			isMoving = NO;
			self.backgroundView.hidden = YES;
		}];
		
		return;
	}
	// it keeps move with touch
	if (isMoving) {
		[self viewMoveAanimationWithPoint:touchPoint.x - startedPoint.x];
	}
}

-(void) dealloc
{
	if (_backgroundView) {
		
	}
	if (blackMask) {
		blackMask = nil;
	}
	if (lastScreenShotView) {
		lastScreenShotView = nil;
	}
	
    self.lastPushClass = nil;
    self.lastPushDate = nil;
	
}

@end

