//
//  CHUserMode.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHUser.h"

@implementation CHUser

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contactType = [NSNumber numberWithInteger:CHContactUser];
    }
    return self;
}

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"itemId":@"id",
                           @"itemName":@"name",
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
