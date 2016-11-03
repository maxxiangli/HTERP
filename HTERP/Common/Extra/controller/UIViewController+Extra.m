//
// UIViewController+Extra.m
// IntelligentHome
//
// Created by zheliang on 周日 2013-11-10.
// Copyright (c) 2013年 zheliang. All rights reserved.
//

#import "UIViewController+Extra.h"
#import "UIViewAdditions.h"

@implementation UIViewController (Extra)

+ (id)controller
{
    return [[[self class] alloc] initWithNibName:nil bundle:nil] ;
}

+ (id)controllerWithNib
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil] ;
}

+ (id)controllerWithClass:(NSString*)classString
{
    return [NSClassFromString(classString) controller];
}



@end
