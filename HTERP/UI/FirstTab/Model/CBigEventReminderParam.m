//
//  CBigEventReminderParam.m
//  QQStock
//
//  Created by li xiang on 16/6/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CBigEventReminderParam.h"

@implementation CBigEventReminderParam

+ (NSString *)serverAddress
{
    NSString *url = [NSString stringWithFormat:@"http://%@/appstock/news/noticeList/", @"ifzq.gtimg.cn"];
    //    http://ifzq.gtimg.cn/appstock/news/noticeList/getBigEvent?symbol=sz300362
    return url;
}

+ (NSString *)path
{
    return @"getBigEvent";
}

- (NSInteger)n
{
    return 20;
}
@end
