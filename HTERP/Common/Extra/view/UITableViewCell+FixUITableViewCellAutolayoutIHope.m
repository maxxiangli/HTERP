//
//  UITableViewCell+FixUITableViewCellAutolayoutIHope.m
//  QQStock
//
//  Created by zheliang on 15/5/20.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "UITableViewCell+FixUITableViewCellAutolayoutIHope.h"
#import <objc/runtime.h>

@implementation UITableViewCell (FixUITableViewCellAutolayoutIHope)
//+ (void)load
//{
//    if (isiOS6) {
//        Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
//        Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
//        
//        method_exchangeImplementations(existing, new);
//    }
//    
//}

- (void)_autolayout_replacementLayoutSubviews
{
    [super layoutSubviews];
    [self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
    [super layoutSubviews];
}

@end
