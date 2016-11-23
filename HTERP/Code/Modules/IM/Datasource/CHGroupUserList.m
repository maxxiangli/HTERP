//
//  CHGroupUserList.m
//  HTERP
//
//  Created by macbook on 23/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHGroupUserList.h"

@implementation CHGroupUserList

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"users":@"data"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}


@end
