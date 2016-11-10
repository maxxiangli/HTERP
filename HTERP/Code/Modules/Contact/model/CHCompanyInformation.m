//
//  CHCompanyInformation.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCompanyInformation.h"

@implementation CHCompanyInformation

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"companyId":@"id"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
