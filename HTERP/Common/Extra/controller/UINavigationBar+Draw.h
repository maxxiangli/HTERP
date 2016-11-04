//
//  UINavigationBar+Draw.h
//  QQStock
//
//  Created by suning wang on 11-11-5.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Draw)

+(void) navigationBarEnhancement;
+ (void) setCustomBackgroundColor:(UIColor*)color;
+ (void) setCustomBackgroundImage:(UIImage*)backgroundImage;
+ (void) setNeedsLayoutDeep:(UIView*)view;

@end
