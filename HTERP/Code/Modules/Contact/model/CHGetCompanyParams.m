//
//  CHGetCompanyParams.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHGetCompanyParams.h"

@implementation CHGetCompanyParams

+ (NSString *)serverAddress
{
    NSString *url = @"http://182.254.208.132";
    return url;
}

+ (NSString *)path
{
    return @"/Company/getCompany";
}

@end
