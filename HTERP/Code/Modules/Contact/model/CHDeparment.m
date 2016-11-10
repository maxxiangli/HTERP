//
//  CHDeparment.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHDeparment.h"

@implementation CHDeparment

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"deparmentId":@"id", @"deparments":@"branchList"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
