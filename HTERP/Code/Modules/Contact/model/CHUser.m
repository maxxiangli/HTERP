//
//  CHUserMode.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHUser.h"

@implementation CHUser

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"userId":@"id",
                           @"name":@"name",
                           @"mobile":@"mobile",
                           @"companyId":@"companyId",
                           @"branchId":@"branchId",
                           @"email":@"email",
                           @"phone":@"phone",
                           @"status":@"status",
                           @"nickname":@"nickname",
                           @"imgurl":@"imgurl"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
