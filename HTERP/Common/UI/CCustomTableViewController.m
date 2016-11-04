//
//  CCustomTableViewController.m
//  QQStock
//
//  Created by zheliang on 14/11/25.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "CCustomTableViewController.h"
#import "CNavigationController.h"

@interface CCustomTableViewController ()

@end

@implementation CCustomTableViewController

@synthesize isAppeared = _isAppeared;

- (id) init
{
	self = [super init];
	if (self)
	{
		self.stateController = [[CStateController alloc] init] ;
		self.stateController.controller = self;
		self.isGestureBack = NO;
		//		self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self)
	{
		self.stateController = [[CStateController alloc] init] ;
		self.stateController.controller = self;
		self.isGestureBack = NO;
		//		self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
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
//		self.edgesForExtendedLayout =  UIRectEdgeNone;
	}
#endif
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil] ;
	[[self navigationItem] setBackBarButtonItem:backButton];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
#if iOS7SDK
	if ((isThaniOS6)) {
		self.isGestureBack = (self.navigationController.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan);
	} else {
		self.isGestureBack = NO;
	}
#else
	self.isGestureBack = NO;
#endif
	
	self.isAppeared = YES;
	[super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	self.isAppeared = NO;
	[super viewDidDisappear:animated];
}

-(void) disableInteractivePopGesture
{
#if iOS7SDK
	if ((isThaniOS6)) {
		if(self.navigationController.interactivePopGestureRecognizer) self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
////	CGRect v = CGRectMake(CGRectGetMinX(viewFrame), heightOffset, CGRectGetWidth(viewFrame), CGRectGetHeight(appFrame) - heightOffset - CGRectGetHeight(navBarFrame) - kCustomTabBarDefaultHeight);
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
