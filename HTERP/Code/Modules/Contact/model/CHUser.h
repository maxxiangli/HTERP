//
//  CHUserMode.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"

@protocol CHUser
@end

@interface CHUser : CJSONModel

@property(nonatomic, strong)NSString<Optional> *userId;
@property(nonatomic, strong)NSString<Optional> *name;
@property(nonatomic, strong)NSString<Optional> *mobile;
@property(nonatomic, strong)NSString<Optional> *companyId;
@property(nonatomic, strong)NSString<Optional> *branchId;
@property(nonatomic, strong)NSString<Optional> *email;
@property(nonatomic, strong)NSString<Optional> *phone;
@property(nonatomic, strong)NSString<Optional> *status;
@property(nonatomic, strong)NSString<Optional> *nickname;
@property(nonatomic, strong)NSString<Optional> *imgurl;






//@protocol CBigEventReminderItemModel
//@end
//
//@interface CBigEventReminderItemModel : CJSONModel
//
//@property (nonatomic, strong) NSString <Optional>*stockCode;       // 代码：sz300362
//@property (nonatomic, strong) NSString <Optional>*date;       // 日期：2016－04-26
//@property (nonatomic, strong) NSString <Optional>*typeStr;       // 类型：业绩披露
//@property (nonatomic, strong) NSString <Optional>*content;     // 内容：
//@property (nonatomic, strong) NSString <Optional>*noticeId;       // 公告id
//@property (nonatomic, strong) NSString <Optional>*title;        // title：天祥环境：2016年第一季度报告全文
//- (NSString *)year;
//- (NSString *)monthDay;
//@end


@end
