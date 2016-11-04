//
//  CBigEventReminderParam.h
//  QQStock
//
//  Created by li xiang on 16/6/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CRequestParams.h"

@interface CBigEventReminderParam : CRequestBaseParams
@property (nonatomic, copy)         NSString *symbol;
@property (nonatomic, assign)       NSInteger page;
@property (nonatomic, assign)       NSInteger n;
@end