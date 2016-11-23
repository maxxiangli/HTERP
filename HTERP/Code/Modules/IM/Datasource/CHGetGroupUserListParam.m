//
//  CHGetGroupUserListParam.m
//  HTERP
//
//  Created by macbook on 23/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHGetGroupUserListParam.h"

@implementation CHGetGroupUserListParam

+ (NSString *)serverAddress
{
    NSString *url = @"http://182.254.208.132";
    return url;
}

+ (NSString *)path
{
    return @"/chat/getRoomUserList";
}

@end
