//
//  CBigEventReminderModel.h
//  QQStock
//
//  Created by li xiang on 16/6/6.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CRequestJSONModelBase.h"

@protocol CBigEventReminderItemModel
@end

@interface CBigEventReminderItemModel : CJSONModel

@property (nonatomic, strong) NSString <Optional>*stockCode;       // 代码：sz300362
@property (nonatomic, strong) NSString <Optional>*date;       // 日期：2016－04-26
@property (nonatomic, strong) NSString <Optional>*typeStr;       // 类型：业绩披露
@property (nonatomic, strong) NSString <Optional>*content;     // 内容：
@property (nonatomic, strong) NSString <Optional>*noticeId;       // 公告id
@property (nonatomic, strong) NSString <Optional>*title;        // title：天祥环境：2016年第一季度报告全文
- (NSString *)year;
- (NSString *)monthDay;
@end

@interface CBigEventReminderModel : CRequestJSONModelBase
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSArray<CBigEventReminderItemModel,Optional> *list;
@end
