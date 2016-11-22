//
//  CHCreateGroupModel.m
//  HTERP
//
//  Created by macbook on 22/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCreateGroupModel.h"

@implementation CHCreateGroupModel

+ (JSONKeyMapper *)keyMapper
{
    return  [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId":@"data.id"}];
}


@end
