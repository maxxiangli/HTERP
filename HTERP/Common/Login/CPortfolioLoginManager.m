//
//  CPortfolioLoginManager.m
//  QQStock_lixiang
//
//  Created by xiang li on 14-1-7.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "CPortfolioLoginManager.h"

#define KPortfolioLoginFile      @"loginInfor_1"

static CPortfolioLoginManager *instance = nil;


@implementation CPortfolioLoginManager

+ (CPortfolioLoginManager *)getInstance
{
    if (nil == instance) {
        instance = [[CPortfolioLoginManager alloc] init];
    }
    return instance;
}
@end
