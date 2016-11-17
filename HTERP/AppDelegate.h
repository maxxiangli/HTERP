//
//  AppDelegate.h
//  HTERP
//
//  Created by 王振宇 on 2016/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTGlobal.h"
#import "RDVTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RDVTabBarController *tabBarController;

-(UINavigationController*) currentController;
- (UIViewController *)getAppRootController;
@end

