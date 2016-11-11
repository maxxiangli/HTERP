//
//  CLoginLoginParam.m
//  HTERP
//
//  Created by li xiang on 2016/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CLoginLoginParam.h"

@implementation CLoginLoginParam
+ (NSString *)serverAddress
{
    NSString *url = @"http://182.254.208.132";
    return url;
}

+ (NSString *)path
{
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return @"/user/login";
}
@end
