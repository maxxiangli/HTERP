//
//  CLoginSmsCodeParam.m
//  HTERP
//
//  Created by li xiang on 16/11/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CLoginSmsCodeParam.h"

@implementation CLoginSmsCodeParam
+ (NSString *)serverAddress
{
    NSString *url = @"http://182.254.208.132";
    return url;
}

+ (NSString *)path
{
    return @"/sms/sendCode";
}
@end
