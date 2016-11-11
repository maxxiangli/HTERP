//
//  AppDelegate.m
//  HTERP
//
//  Created by 王振宇 on 2016/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarItem.h"
#import "CNavigationController.h"
#import "CBigEventController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    [UINavigationBar navigationBarEnhancement];
    [UINavigationBar setCustomBackgroundImage:BUNDLEIMAGE(@"stock_navi_bg_128.png")];
    
    //初始化字号
    initFontTypeFor6p();
    
    // 状态栏样式
    UIApplication *statusBar = [UIApplication sharedApplication];
    // add by wangsn start for plist文件中增加了一句初试隐藏状态条的语句，所以这里把状态条打开
    [statusBar setStatusBarHidden:NO];
    // add by wangsn end
    [statusBar setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    //加载一些数据
    [GLOBEL_LOGIN_OBJECT loadLoginData];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Methods

- (void)setupViewControllers {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"StockDetail" bundle:nil];
    CBigEventController *bigEventController = [storyBoard instantiateViewControllerWithIdentifier:@"CBigEventController"];
    bigEventController.stockCode = @"sz002816";
    bigEventController.stockName = @"海汽集团";

    UIViewController *firstNavigationController = [[CNavigationController alloc]
                                                   initWithRootViewController:bigEventController];
    
    UIStoryboard *secondstoryboard = [UIStoryboard storyboardWithName:@"HTSecondTabStoryboard" bundle:nil];
    SecondViewController *secondViewController = [secondstoryboard instantiateViewControllerWithIdentifier:@"secondViewController"];
    UIViewController *secondNavigationController = [[CNavigationController alloc]
                                                   initWithRootViewController:secondViewController];
    
    UIStoryboard *thirdStoryboard = [UIStoryboard storyboardWithName:@"HTThirdTabStoryboard" bundle:nil];
    ThirdViewController *thirdViewController = [thirdStoryboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
    UIViewController *thirdNavigationController = [[CNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    UIStoryboard *fourthStoryboard = [UIStoryboard storyboardWithName:@"HTFourthTabStoryboard" bundle:nil];
    FourthViewController *fourthViewController = [fourthStoryboard instantiateViewControllerWithIdentifier:@"fourthViewController"];
    UIViewController *fourthNavigationController = [[CNavigationController alloc]
                                                   initWithRootViewController:fourthViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController, fourthNavigationController]];
    self.tabBarController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third", @"fourth"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

-(UINavigationController*) currentController
{
    UIViewController *selectViewCtrl = self.tabBarController.selectedViewController;
    if ([selectViewCtrl isKindOfClass:[UISplitViewController class]]) {
        if (!isiOS8Later) return nil;
        UISplitViewController *theSplitCtrl = (UISplitViewController*) self.tabBarController.selectedViewController;
        NSArray *viewCtrls = theSplitCtrl.viewControllers;
        if (!viewCtrls.count) return nil;
        UINavigationController *primaryViewController = [viewCtrls lastObject];
        return primaryViewController;
    } else if ([selectViewCtrl isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *) self.tabBarController.selectedViewController;
    }
    return nil;
}
@end
