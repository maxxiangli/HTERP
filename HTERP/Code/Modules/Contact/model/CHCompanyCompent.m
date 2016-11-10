//
//  CHCompanyGroup.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCompanyCompent.h"

@implementation CHCompanyCompent

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"companyInfo":@"companyInfo", @"deparment":@"branchList"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
