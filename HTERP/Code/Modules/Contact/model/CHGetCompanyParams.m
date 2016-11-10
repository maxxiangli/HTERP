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
    NSString *url = @"http://www.alleasy.com/Company/";
    return url;
}

+ (NSString *)path
{
    return @"getCompany";
}

@end
