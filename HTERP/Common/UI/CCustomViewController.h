//
//  CCustomViewController.h
//  QQStock
//
//  Created by suning wang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CStateController.h"

@interface CCustomViewController : UIViewController
{
}

@property(nonatomic, retain) CStateController *stateController;
@property(nonatomic, assign) BOOL isAppeared;
@property(nonatomic, assign) BOOL isGestureBack;
@property(nonatomic, assign) BOOL isNavigationBarTranparent;
@property(nonatomic, assign) BOOL isFullScreenLayout;

- (BOOL)isVisible;

- (void) doChangeTheme;

- (void) disableInteractivePopGesture;
- (void) enableInteractivePopGesture;
- (void) fullScreenMode;
@end
