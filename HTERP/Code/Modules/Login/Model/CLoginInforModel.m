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

//数据有效性（例如：缺少session）
- (BOOL)dataIsValid
{
    if ( ![self.session isKindOfClass:[NSString class]] )
    {
        return NO;
    }
    
    if ( ![self.userId isKindOfClass:[NSString class]] )
    {
        return NO;
    }
    
    return YES;
}
@end
