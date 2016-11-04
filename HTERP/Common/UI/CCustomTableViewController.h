//
//  CCustomTableViewController.h
//  QQStock
//
//  Created by zheliang on 14/11/25.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCustomTableViewController : UITableViewController
@property(nonatomic, retain) CStateController *stateController;
@property(nonatomic, assign) BOOL isAppeared;
@property(nonatomic, assign) BOOL isGestureBack;

- (BOOL)isVisible;

-(void) doChangeTheme;

-(void) disableInteractivePopGesture;
-(void) enableInteractivePopGesture;

@end
