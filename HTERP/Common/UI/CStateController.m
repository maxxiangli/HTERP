//
//  CPortfolioController.m
//  QQStock_lixiang
//
//  Created by xiang li on 13-10-11.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "CStateController.h"

@implementation CStateController
@synthesize controller = _controller;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc
{

    
}

//0:隐藏     1:显示    2:切换
- (NSInteger)getSwitchTypCurrent:(id)first next:(id)second
{
    NSInteger switchType = 0;//0:隐藏     1:显示    2:切换
    if ( first && second )
    {
        switchType = 2;
    }
    else if ( first )
    {
        switchType = 0;
    }
    else if ( second )
    {
        switchType = 1;
    }
    else
    {
        switchType = 0;
    }
    
    return switchType;
}

- (void)modifyLeftButtonItem:(id)leftButtonItem
{
    if ( self.controller && self.controller.navigationItem)
    {
        self.controller.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

- (void)modifyRightButtonItem:(id)rightButtonItem
{
    if ( self.controller && self.controller.navigationItem)
    {
        self.controller.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

- (void)modifyLeftButtonItem:(id)leftButtonItem animated:(BOOL)animated delay:(NSTimeInterval)delay
{
    UIView *lastView = nil;
    UIView *currView = [leftButtonItem customView];
    
    if ( !self.controller || !self.controller.navigationItem)
    {
        return;
    }
    
    if ( !animated )
    {
        self.controller.navigationItem.leftBarButtonItem = leftButtonItem;
        return;
    }
    
    lastView = [self.controller.navigationItem.leftBarButtonItem customView];
    NSInteger switchType = [self getSwitchTypCurrent:lastView next:leftButtonItem];//0:隐藏     1:显示    2:切换
    NSTimeInterval animationFirst = 0.f;
    NSTimeInterval animationSecond = 0.f;
    if ( 0 == switchType )
    {
        animationFirst = 0.4;
        animationSecond = 0;
    }
    if ( 1 == switchType )
    {
        animationFirst = 0;
        animationSecond = 0.4;
    }
    else if ( 2 == switchType )
    {
        animationFirst = 0.2;
        animationSecond = 0.2;
    }
    else
    {
        animationFirst = 0.2;
        animationSecond = 0.2;
    }
    
    [UIView animateWithDuration:animationFirst
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         lastView.alpha = 0.f;
                         
                     }
                     completion:^(BOOL finished){
                         self.controller.navigationItem.leftBarButtonItem = leftButtonItem;
                         currView.alpha = 0.f;
                         [UIView animateWithDuration:animationSecond
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^(void){
                                              
                                              currView.alpha = 1.f;
                                              
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
    
    

}

- (void)modifyLeftButtonItem:(id)leftButtonItem animated:(BOOL)animated
{
    [self modifyLeftButtonItem:leftButtonItem animated:animated delay:0];
}

- (void)modifyRightButtonItem:(id)rightButtonItem animated:(BOOL)animated delay:(NSTimeInterval)delay
{
    UIView *lastView = nil;
    UIView *currView = [rightButtonItem customView];
    
    if ( !self.controller || !self.controller.navigationItem)
    {
        return;
    }
    
    if ( !animated )
    {
        self.controller.navigationItem.rightBarButtonItem = rightButtonItem;
        return;
    }
    
    lastView = [self.controller.navigationItem.rightBarButtonItem customView];
    NSInteger switchType = [self getSwitchTypCurrent:lastView next:rightButtonItem];//0:隐藏     1:显示    2:切换
    NSTimeInterval animationFirst = 0.f;
    NSTimeInterval animationSecond = 0.f;
    if ( 0 == switchType )
    {
        animationFirst = 0.4;
        animationSecond = 0;
    }
    if ( 1 == switchType )
    {
        animationFirst = 0;
        animationSecond = 0.4;
    }
    else if ( 2 == switchType )
    {
        animationFirst = 0.2;
        animationSecond = 0.2;
    }
    else
    {
        animationFirst = 0.2;
        animationSecond = 0.2;
    }
    
    [UIView animateWithDuration:animationFirst
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         lastView.alpha = 0.f;
                         
                     }
                     completion:^(BOOL finished){
                         self.controller.navigationItem.rightBarButtonItem = rightButtonItem;
                         currView.alpha = 0.f;
                         [UIView animateWithDuration:animationSecond
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^(void){
                                              
                                              currView.alpha = 1.f;
                                              
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];

}

- (void)modifyRightButtonItem:(id)rightButtonItem animated:(BOOL)animated
{
    [self modifyRightButtonItem:rightButtonItem animated:animated delay:0];
}

- (void)showCustomTabBar
{
//    if ( self.controller )
//    {
//        [self.controller showCustomTabBar];
//    }
}
- (void)hideCustomTabBar
{
//    if ( self.controller )
//    {
//        [self.controller hideCustomTabBar];
//    }
}

- (void)showCustomTabBarWithNoAnimation
{
//    if ( self.controller )
//    {
//        [self.controller showCustomTabBarWithNoAnimation];
//    }
}

- (void)hideCustomTabBarWithNoAnimation
{
//    if ( self.controller )
//    {
//        [self.controller hideCustomTabBarWithNoAnimation];
//    }
}
@end
