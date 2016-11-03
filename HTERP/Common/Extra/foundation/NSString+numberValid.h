//
//  NSString+numberValid.h
//  QQStock
//
//  Created by michaelxing on 15/2/3.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (numberValid)

+ (BOOL)isLegalNumber:(NSString*)string;
+ (BOOL)isLegalInteger:(NSString*)string;
+ (BOOL)isLegalFloat:(NSString *)string;

@end
