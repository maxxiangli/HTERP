//
//  CCustomViewController.m
//  QQStock
//
//  Created by suning wang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "CCustomViewController.h"
#import "CNavigationController.h"

@implementation CCustomViewController
@synthesize isAppeared = _isAppeared;

- (id) init
{
	self = [super init];
	if (self)
	{
		self.stateController = [[CStateController alloc] init] ;
		self.stateController.controller = self;
		self.isGestureBack = NO;
		self.isNavigationBarTranparent = NO;
		self.isFullScreenLayout = NO;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
#if	iOS7SDK
	if ((isThaniOS6)) {
//		self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
		self.automaticallyAdjustsScrollViewInsets = NO;		
		self.edgesForExtendedLayout =  UIRectEdgeNone;
	}
#endif
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil] ;
	[[self navigationItem] setBackBarButtonItem:backButton];
    
//    NSLog(@"mazingwang --- %@", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) fullScreenMode {
	if (isiOS6) return;
	if (self.navigationController && self.navigationController.navigationBar) {
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		self.navigationController.navigationBar.translucent = YES;
	}
	self.automaticallyAdjustsScrollViewInsets = YES;
	self.extendedLayoutIncludesOpaqueBars = YES;
	self.edgesForExtendedLayout =  UIRectEdgeAll;
	self.isFullScreenLayout = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];	
#if iOS7SDK
	if ((isThaniOS6)) {
		UIGestureRecognizerState recognizerState = self.navigationController.interactivePopGestureRecognizer.state;
//		self.isGestureBack = (self.navigationController.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan);
		self.isGestureBack = (recognizerState == UIGestureRecognizerStateBegan) || (recognizerState == UIGestureRecognizerStateChanged);
	} else {
		self.isGestureBack = NO;
	}
#else
	self.isGestureBack = NO;
#endif

	self.isAppeared = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
	self.isAppeared = NO;
	[super viewDidDisappear:animated];
	if (self.navigationController && [self.navigationController isKindOfClass:[CNavigationController class]]) {
		[((CNavigationController*) self.navigationController ) updateNavigationBarTranparent];
	}
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    const char * className = object_getClassName(self);
    if(strcmp(className,"CMyViewController") == 0
       || strcmp(className,"CMarketViewController") == 0
       || strcmp(className,"CStockListViewController") == 0
       || strcmp(className,"CStockDetailController") == 0)
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//        [[UIScreen mainScreen] setBrightness:1];
    }
    else
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//        [[UIScreen mainScreen] setBrightness:0.3];
    }
}

-(void) disableInteractivePopGesture
{
#if iOS7SDK
	if ((isThaniOS6)) {
		if(self.navigationController.interactivePopGestureRecognizer) self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [((CNavigationController*) self.navigationController) setAllowDragBack:NO];

	}
#endif
	if (!(isThaniOS6)) {
		[((CNavigationController*) self.navigationController) setAllowDragBack:NO];
	}
}

-(void) enableInteractivePopGesture
{
#if iOS7SDK
	if ((isThaniOS6)) {
		if(self.navigationController.interactivePopGestureRecognizer) self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [((CNavigationController*) self.navigationController) setAllowDragBack:YES];

	}
#endif
	if (!(isThaniOS6)) {
		[((CNavigationController*) self.navigationController) setAllowDragBack:YES];
	}
}

//- (void)viewWillLayoutSubviews
//{
//	[super viewWillLayoutSubviews];
////	int currentHeight	= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
////	CGRect viewFrame	= self.view.frame;
////	CGRect navBarFrame	= self.navigationController.navigationBar.frame;
////	CGRect appFrame = [[UIScreen mainScreen] bounds];
////
////	int heightOffset = currentHeight + CGRectGetHeight(navBarFrame);
////	CGRect v = CGRectMake(CGRectGetMinX(viewFrame), heightOffset, CGRectGetWidth(viewFrame), CGRectGetHeight(appFrame) - heightOffset - CGRectGetHeight(navBarFrame) - SZ_CustomTabBar_Height);
////	self.view.frame = v;
//
////	int currentHeight	= CGRectGetHeight(application.statusBarFrame);
////	CGRect viewFrame	= self.currentController.view.frame;
////	CGRect navBarFrame	= self.currentController.navigationBar.frame;
////
////	int heightOffset = currentHeight - (CGRectGetMinY(viewFrame) + CGRectGetMinY(navBarFrame));
////	viewFrame = CGRectMake(0, CGRectGetMinY(viewFrame) + heightOffset, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame) - heightOffset);
//}
//
//- (void)viewDidLayoutSubviews
//{
//	[super viewDidLayoutSubviews];
//}

- (BOOL)isVisible
{
    if(self.view.window)
    {
        // view visible
        return YES;
    }
    else
    {
        // no visible
        return NO;
    }
}

-(void) doChangeTheme
{
	if (isiOS5 || isiOS6 || isThaniOS6)
	{
		if ((isThaniOS6)) {
			[self.navigationController.navigationBar setBackgroundImage:BUNDLEIMAGE((isThaniOS6)?@"stock_navi_bg_128.png":@"stock_navi_bg.png")
														  forBarMetrics:UIBarMetricsDefault];
			
			[self.navigationController.navigationBar setTintColor:TC_NavigationBarTintColor];
			
		} else {
			[self.navigationController.navigationBar setBackgroundImage:BUNDLEIMAGE(@"stock_navi_bg.png")
														  forBarMetrics:UIBarMetricsDefault];
			if (isiOS6) {
				[self.navigationController.navigationBar setShadowImage:BUNDLEIMAGE(@"shadowImage.png")];
			}
			if (eThemeBlueWhite == [CConfiguration sharedConfiguration].themeType)
			{
				[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.1 green:0.35 blue:0.5 alpha:1]];
			} else {
				[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
			}
		}
		
	} else { //iOS 5 以下.
		[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:BUNDLEIMAGE(@"stock_navi_bg.png")]];
	}
}


- (void) dealloc
{
    self.stateController.controller = nil;
    self.stateController = nil;
    
	
}

@end
