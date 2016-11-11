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
    NSString *url = @"http://www.alleasy.com";
    return url;
}

+ (NSString *)path
{
    return @"/user/login";
}
@end
