//
//  HttpDnsWhitelistRequest.h
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONRequestCommand.h"

// 白名单请求
@interface HttpDnsWhitelistRequest : CJSONRequestCommand

// 需要更新的表名
@property (nonatomic, copy) NSString *tableName;

@end

// 白名单记录条目模型
@protocol HttpDnsWhitelistItemModel
@end
@interface HttpDnsWhitelistItemModel : CJSONModel

@property (nonatomic, assign) NSInteger TTL;
@property (nonatomic, strong) NSString  *domain;

@end

// 白名单模型
@protocol HttpDnsWhitelistModel
@end
@interface HttpDnsWhitelistModel : CRequestJSONModelBase

@property (nonatomic, strong) NSString *dnsip;
@property (nonatomic, strong) NSArray<HttpDnsWhitelistItemModel>  *domains;

@end

// 白名单请求参数
@interface HttpDnsWhitelistParams : CRequestBaseParams

@end