//
//  HttpDnsRecordRequest.h
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONRequestCommand.h"

@interface HttpDnsRecordRequest : CRequestCommand

// 所属的表名，返回时需与当前表名匹配
@property (nonatomic, copy) NSString *tableName;
// 请求的host
@property (nonatomic, copy) NSString *host;
// 返回的IP列表
@property (nonatomic, retain) NSArray *ipArray;

@end
