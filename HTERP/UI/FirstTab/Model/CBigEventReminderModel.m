//
//  CBigEventReminderModel.m
//  QQStock
//
//  Created by li xiang on 16/6/6.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CBigEventReminderModel.h"

@implementation CBigEventReminderItemModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"symbol":@"stockCode",
                                                       @"date":@"date",
                                                       @"type":@"typeStr",
                                                       @"type":@"typeStr",
                                                       @"desc":@"content",
                                                       @"notice_id":@"noticeId",
                                                       @"title":@"title"}];
}

- (NSString *)year
{
    if ( [self.date isKindOfClass:[NSString class]] )
    {
        NSRange range = [self.date rangeOfString:@"-"];
        if ( range.length )
        {
            return [self.date substringToIndex:range.location];
        }
    }
    
    return nil;
}

- (NSString *)monthDay
{
    if ( [self.date isKindOfClass:[NSString class]] )
    {
        NSRange range = [self.date rangeOfString:@"-"];
        if ( range.length )
        {
            return [self.date substringFromIndex:range.location + 1];
        }
    }
    
    return nil;
}
@end

@implementation CBigEventReminderModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.data":@"list",
                                                       @"data.total_num":@"totalNum",
                                                       @"data.total_page":@"totalPage"}];
}
@end
