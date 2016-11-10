//
//  CHContactList.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactList.h"

@implementation CHContactList

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"contactList":@"data"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
