//
// UIViewController+Extra.h
// IntelligentHome
//
// Created by zheliang on 周日 2013-11-10.
// Copyright (c) 2013年 zheliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extra)

+ (id)controller;
+ (id)controllerWithNib;
+ (id)controllerWithClass:(NSString*)classString;

@end
