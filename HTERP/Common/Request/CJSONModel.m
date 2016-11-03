//
//  CJSONModel.m
//  QQStock
//
//  Created by zheliang on 14/12/2.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "CJSONModel.h"

@implementation CJSONModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        [self configModel];
    }
    
    return self;
}

- (void)configModel
{
    
}




@end
