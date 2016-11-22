//
//  CHCreateGroupParam.m
//  HTERP
//
//  Created by macbook on 22/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCreateGroupParam.h"

@implementation CHCreateGroupParam

+ (NSString *)serverAddress
{
    NSString *url = @"http://182.254.208.132";
    return url;
}

+ (NSString *)path
{
    return @"/chat/createRoom";
}

@end
