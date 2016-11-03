//
//  UILabel+Extra.h
//  QQStock
//
//  Created by mazingwang on 16/3/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UILabel (UILabel_Extra)
- (void)ex_setText:(NSString *)text withLineSpace:(CGFloat)lineSpace withBreakModel:(NSLineBreakMode) breakModel;
@end
