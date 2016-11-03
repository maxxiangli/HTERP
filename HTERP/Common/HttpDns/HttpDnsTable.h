//
//  HttpDnsTable.h
//  QQStock
//
//  Created by abelchen on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HttpDnsDefaultTableName @"DefaultDNSTable"

/***************************
 *  本地Http DNS 记录
 **************************/
@interface HttpDnsRecord : NSObject<NSCopying>

// 记录有效生存时间，到期刷新，单位s
@property (nonatomic, assign) NSInteger            TTL;
// 匹配的Host Name
@property (nonatomic, copy  ) NSString             *host;
// 指向的地址
@property (nonatomic, copy  ) NSString             *address;

// 记录所属的表名
@property (nonatomic, copy  ) NSString             *ownerTableName;
// 条目刷新时间戳
@property (nonatomic, assign) NSTimeInterval       timestamp;
// 是否处于更新状态
@property (nonatomic, assign) BOOL                 isUpdating;
// 记录是否有效
@property (nonatomic, assign) BOOL                 isValid;
// 记录当前记录的修改版本，用于避免时序问题，比如：
// Request使用了记录(此时指向的ip不能正常访问) -> Dns记录刷新(刷新成正常ip) -> Request返回异常 -> Dns记录置为无效
@property (nonatomic, assign) NSUInteger           version;

// 生成状态字符串
@property (nonatomic, readonly) NSString           *statusString;

@end

/********************************
 *  本地Http DNS记录管理表
 ********************************/
@interface HttpDnsTable : NSObject<NSCopying>

// 当前表名
@property (nonatomic, copy  ) NSString *name;
// httpdns解析服务器
@property (nonatomic, copy  ) NSString *dnsip;
// 是否处于更新状态
@property (nonatomic, assign) BOOL     isUpdating;
// DNS记录列表
@property (nonatomic, readonly) NSMutableDictionary<NSString*,HttpDnsRecord*> *recordsDict;

// 根据当前name从文件缓存中读取保存的DNS表
- (void)loadFromCache:(NSString*)cachePath;
// 根据当前name将DNS表保存到文件缓存
- (void)saveToCache:(NSString*)cachePath;

@end
