//
//  CCustomUILabel.h
//  QQStock_lixiang
//
//  Created by xiang li on 13-9-16.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCustomUILabel : UILabel

/**初始化一个lable
 *
 */
+ (CCustomUILabel *) labelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold opaque:(BOOL)opaque;
+ (CCustomUILabel *) labelWithPrimaryColor1:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat*)fontSize bold:(BOOL)bold opaque:(BOOL)opaque;


@end