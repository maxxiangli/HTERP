//
//  CHCompanyInformation.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCompanyInformation.h"

@implementation CHCompanyInformation

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contactType = [NSNumber numberWithInteger:CHContactCompanyInfo];
    }
    return self;
}

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"itemId":@"id", @"itemName":@"name"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
