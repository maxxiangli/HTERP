//
//  CLoginInforModel.m
//  HTERP
//
//  Created by li xiang on 2016/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CLoginInforModel.h"

@implementation CLoginInforModel
+ (JSONKeyMapper *)keyMapper
{
    return  [[JSONKeyMapper alloc] initWithDictionary:@{@"data.userId":@"userId",
                                                        @"data.session":@"session"}];
}
@end
