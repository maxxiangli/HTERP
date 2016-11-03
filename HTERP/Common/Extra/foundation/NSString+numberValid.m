//
//  NSString+numberValid.m
//  QQStock
//
//  Created by michaelxing on 15/2/3.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "NSString+numberValid.h"

@implementation NSString (numberValid)

+ (BOOL)isLegalNumber:(NSString*)string
{
    if (string == nil) {
        return NO;
    }
    return [self isLegalInteger:string] || [self isLegalFloat:string];
}

+ (BOOL)isLegalInteger:(NSString*)string
{
    if (string == nil) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:string];
    NSInteger intVal;
    
    return [scan scanInteger:&intVal] && [scan isAtEnd];
}

+ (BOOL)isLegalFloat:(NSString *)string
{
    if (string == nil) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:string];
    float   floatVal;
    
    return [scan scanFloat:&floatVal] && [scan isAtEnd];
}

@end
