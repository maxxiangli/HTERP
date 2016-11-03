//
//  UILabel+Extra.m
//  QQStock
//
//  Created by mazingwang on 16/3/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "UILabel+Extra.h"

@implementation UILabel (UILabel_Extra)

- (void)ex_setText:(NSString *)text withLineSpace:(CGFloat)lineSpace withBreakModel:(NSLineBreakMode) breakModel{
    if (!text || [text length] == 0) {
        [self setText:@""];
        return;
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:breakModel];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];  // 设置行间距
    self.attributedText = attStr;
}

@end
