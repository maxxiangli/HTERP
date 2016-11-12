//
//  CHDeparment.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHDeparment.h"

@implementation CHDeparment

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.itemType = [NSNumber numberWithInteger:CHContactDepartment];
    }
    return self;
}


+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"itemId":@"id", @"deparments":@"branchList", @"itemName":@"name"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
