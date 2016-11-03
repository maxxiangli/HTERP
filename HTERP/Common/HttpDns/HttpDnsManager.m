//
//  HttpDnsManager.m
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsManager.h"
#import "HttpDnsDebug.h"
#import "HttpDnsWhitelistRequest.h"
#import "HttpDnsRecordRequest.h"
#import "Reachability.h"
#import "HttpDnsUtility.h"

#define HttpDnsRecordMinTTL 60

@interface HttpDnsManager ()<CJSONRequestCommandDelegate, CRequestCommandDelegate>
// 白名单
@property (nonatomic, retain) HttpDnsTable *dnsTable;
// 操作队列
@property (nonatomic, strong)  dispatch_queue_t queue;

@end

// 队列dispatch宏
#define DISPATCH_BARRIER_ASYNC dispatch_barrier_async(self.queue, ^(){
#define DISPATCH_BARRIER_SYNC dispatch_barrier_sync(self.queue, ^(){
#define DISPATCH_SYNC   dispatch_sync(self.queue, ^(){
#define DISPATCH_END });

@implementation HttpDnsManager

#pragma mark - Basic
/***********************************
 初始化
 ***********************************/

+ (HttpDnsManager*)sharedManager {
    static HttpDnsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HttpDnsManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if(self){
        // 创建操作队列
        _queue = dispatch_queue_create("HttpDnsManager.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        // 初始化DNS表
        _dnsTable = [[HttpDnsTable alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self stopObserveReachability]; // 停止监听网络变化
    Safe_Release(_dnsTable);
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.dnsTable];
}

#pragma mark - DNS表操作
/***********************************************************
 白名单和DNS记录操作，保证线程安全，不可互相调用
 ***********************************************************/

// 启用或禁用HttpDns，做监听的初始化 ----- User Interface
- (void)setEnabled:(BOOL)enabled {
    if(DISABLE_HTTPDNS){
        _enabled = NO;
        return;
    }
    DISPATCH_BARRIER_SYNC
    if(_enabled != enabled){
        _enabled = enabled;
        if(enabled){
            // 生成当前DNS表名
            NetworkStatus reachableStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
            NSString *newDnsTableName = [self generateDnsTableName: reachableStatus];
            // 更新表名
            [self changeDnsTableName:newDnsTableName];
            // 开始监听网络变化
            [self startObserveReachability];
            DNSLog(@"enable");
        }else{
            // 取消监听
            [self stopObserveReachability];
            DNSLog(@"disable");
        }
    }
    DISPATCH_END
}

// 检查DNS记录更新，非线程安全，内部使用
- (void)checkAndUpdateRecord:(HttpDnsRecord*)record {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if(record.timestamp + record.TTL * 0.75 < now){ // Dns达到更新阀值
        // Dns记录已经过期，让记录失效
        if(record.isValid && record.timestamp + record.TTL < now){
            record.isValid = NO;
            DNSLog(@"check record: expired %@", record);
        }
        // 不在更新状态，发起记录更新
        if(!record.isUpdating){
            [self requestAddressForHost: record.host];
            record.isUpdating = YES;
            DNSLog(@"check record: updating %@", record);
        }
    }
}

// 读取dns记录 ----- User Interface
- (HttpDnsRecord*)recordForHost:(NSString*)host {
    __block HttpDnsRecord *record = nil;
    
    BENCHMARK_START(@"lookup costs") // 调试用计时
    DISPATCH_BARRIER_SYNC
    if(self.enabled){
        HttpDnsRecord *dstRecord = self.dnsTable.recordsDict[host];
        // 检查是否过期
        if(dstRecord){
            // 检查更新
            [self checkAndUpdateRecord:dstRecord];
            // 若记录有效则返回
            if(dstRecord.isValid && dstRecord.address){
                record = [dstRecord copy] ;
                DNSLog(@"lookup dns: valid %@", dstRecord);
            }else{
                DNSLog(@"lookup dns: invalid %@", dstRecord);
            }
            // 调试界面更新
            HttpDnsNotifyChanged
        }else{
            DNSLog(@"lookup dns: not in whitelist [%@]", host);
        }
    }
    DISPATCH_END
    BENCHMARK_END
    
    return record;
}

// 使对应Dns记录失效 ----- User Interface
- (void)invalidateRecord:(HttpDnsRecord*)record {
    if(!record || !record.host) return;
    DISPATCH_BARRIER_SYNC
    if(self.enabled){
        // 记录需要属于当前Dns表
        if([record.ownerTableName isEqualToString: self.dnsTable.name]){
            HttpDnsRecord *dstRecord = self.dnsTable.recordsDict[record.host];
            // 记录版本号需要与当前一致
            if(dstRecord && dstRecord.version == record.version){
                dstRecord.isValid = NO;
                DNSLog(@"invalidate record: [%@]", dstRecord);
                // 通知更新，用于调试
                HttpDnsNotifyChanged
            }
        }
    }
    DISPATCH_END
}

// 触发白名单更新 --- User Interface
- (void)updateWhiteList {
    DISPATCH_SYNC
    if(self.enabled){
        [self requestWhiteList];
    }
    DISPATCH_END
}

// 将数据刷回缓存 --- User Interface
- (void)flushBackTableCache {
    DISPATCH_BARRIER_ASYNC
    if(self.enabled){
        [self.dnsTable saveToCache: self.cacheDirectory];
    }
    DISPATCH_END
}

// 当网络环境变化时，更改当前DNS表名，并发起相关更新操作
- (void)changeDnsTableName:(NSString*)newName {
    DISPATCH_BARRIER_ASYNC
    if(newName){
        // 名字不相同时更新表名
        if(![self.dnsTable.name isEqualToString: newName]){
            // 将当前记录写入缓存
            [self.dnsTable saveToCache: self.cacheDirectory];
            self.dnsTable.name = newName;
            // 读取缓存记录
            [self.dnsTable loadFromCache: self.cacheDirectory];
            DNSLog(@"switch table: [%@]", newName);
            // 更新白名单
            [self requestWhiteList];
            HttpDnsNotifyChanged
        }else{
            DNSLog(@"switch table: keep [%@]", newName);
        }
    }else{
        DNSLog(@"switch table: invalid name [%@]", newName);
    }
    DISPATCH_END
}

// 拉取白名单后更新DNS表
- (void)updateDnsTable:(NSString*)tableName withWhiteList:(HttpDnsWhitelistModel*)whitelist {
    if(!tableName){
        DNSLog(@"update table: nil table name");
        return;
    }
    if(!whitelist){
        DNSLog(@"update table: nil list [%@]", tableName);
        return;
    }
    
    // 两种更新情况，一种是网络变化（之前DNS记录会重新从缓存读取），一种是主动调用（表名不变，之前DNS记录会保留）
    DISPATCH_BARRIER_ASYNC
    // 与当前表名一致，更新
    if([self.dnsTable.name isEqualToString: tableName]){
        // 修改当前dns表信息
        self.dnsTable.dnsip = whitelist.dnsip;
        // 删除不在白名单中的记录
        NSDictionary *recordsDict = [self.dnsTable.recordsDict copy];
        for(NSString *host in recordsDict){
            BOOL inList = NO;
            for(HttpDnsWhitelistItemModel *item in whitelist.domains){
                if(!item.domain) continue;
                if([item.domain isEqualToString: host]){
                    inList = YES;
                    break;
                }
            }
            if(!inList){
                DNSLog(@"update table: remove record [%@]:%@", tableName, self.dnsTable.recordsDict[host]);
                [self.dnsTable.recordsDict removeObjectForKey:host];
            }
        }
        
        // 更新白名单中的记录
        for(HttpDnsWhitelistItemModel *item in whitelist.domains){
            if(!item.domain) continue;
            HttpDnsRecord *curRecord = self.dnsTable.recordsDict[item.domain];
            // 白名单对应记录条目当前不在，则创建
            if(!curRecord){
                curRecord = [[HttpDnsRecord alloc] init];
                curRecord.ownerTableName = self.dnsTable.name;
                curRecord.host = item.domain;
                self.dnsTable.recordsDict[item.domain] = curRecord;
                
            }
            // 设置最小TTL限制，防止更新过于频繁
            if(item.TTL < HttpDnsRecordMinTTL){
                item.TTL = HttpDnsRecordMinTTL;
            }
            curRecord.TTL = item.TTL;
            DNSLog(@"update table: set record [%@]:%@", tableName, curRecord);
            // 检查更新
            [self checkAndUpdateRecord:curRecord];
        }
        self.dnsTable.isUpdating = NO;
        // 通知更新，用于调试
        HttpDnsNotifyChanged
        DNSLog(@"update table: %@", self.dnsTable);
    }else{
        // 表名与当前表名不一致，丢弃
        DNSLog(@"update table: abort [%@]", tableName);
    }
    DISPATCH_END
}

// 查询dns服务器之后，更新dns记录，如果address为nil，则将状态置为Invalid
- (void)updateAddress:(NSString*)address forHost:(NSString*)host inTable:(NSString*)tableName {
    if(!host || !tableName){
        DNSLog(@"update record: invalid parameter [%@]:[%@]", tableName, host);
        return;
    }
    DISPATCH_BARRIER_ASYNC
    if([tableName isEqualToString:self.dnsTable.name]){
        HttpDnsRecord *record = self.dnsTable.recordsDict[host];
        if(record){
            record.host = host;
            record.isUpdating = NO;
            if(address){
                record.address = address;
                record.isValid = YES;
                record.timestamp = [[NSDate date] timeIntervalSince1970];
                DNSLog(@"update record: [%@]:%@", tableName, record);
            }else{
                record.isValid = NO;
                DNSLog(@"update record: invalid [%@]:%@", tableName, record);
            }
            record.version++; // 更新版本号
            // 通知更新，用于调试
            HttpDnsNotifyChanged
        }else{
            DNSLog(@"update record: host dismatch [%@]:[%@]", tableName, host);
        }
    }else{
        // 记录的表名与当前表名不一致，丢弃
        DNSLog(@"update record: table name dismatch [%@]:[%@]", tableName, host);
    }
    DISPATCH_END
}

// 返回当前DnsTable的拷贝，用于调试
- (HttpDnsTable*)currentDnsTable {
    __block HttpDnsTable *table = nil;
    DISPATCH_SYNC
    table = [self.dnsTable copy] ;
    DISPATCH_END
    return table;
}

#pragma mark - 发起网络请求
/***********************************
 网络请求，非线程安全
 ***********************************/

// 发起白名单请求
- (void)requestWhiteList {
    NSString *tableName = self.dnsTable.name;
    // 默认表名表示没有网络，不更新
    if([tableName isEqualToString: HttpDnsDefaultTableName]){
        DNSLog(@"request whitelist: no network [%@]", tableName);
        return;
    }
    if(self.dnsTable.isUpdating){
        DNSLog(@"request whitelist: already updating [%@]", tableName);
        return;
    }
    self.dnsTable.isUpdating = YES;
    // 注意，单例模式不会dealloc，self不会野指针，request开始后会自己retain住，不会野指针
    HttpDnsWhitelistRequest *request = [[HttpDnsWhitelistRequest alloc] initWithDelegate:self modelClass:[HttpDnsWhitelistModel class]];
    // 填上请求对应的table name，防止请求过程中网络环境发生改变，导致数据不对应
    request.tableName = tableName;
    HttpDnsWhitelistParams *params = [[HttpDnsWhitelistParams alloc] init];
    [request getWithParams: params];
    
    
    DNSLog(@"request whitelist: [%@]", tableName);
}

// 发起dns请求
- (void)requestAddressForHost:(NSString*)host {
    if(!host){
        DNSLog(@"request record: invalid host [%@]", host);
        return;
    }
    // 填上请求对应的table name，防止请求过程中网络环境发生改变，导致数据不对应
    NSString *tableName = self.dnsTable.name;
    // 默认表名表示没有网络，不更新
    if([tableName isEqualToString: HttpDnsDefaultTableName]){
        DNSLog(@"request record: no network [%@]", tableName);
        return;
    }
    NSString *dnsip = self.dnsTable.dnsip;
    if(!dnsip){
        DNSLog(@"request record: invalid dnsip [%@]", dnsip);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://%@/d?dn=%@", dnsip, host];
    // 注意，单例模式不会dealloc，self不会野指针，request开始后会自己retain住，不会野指针
    HttpDnsRecordRequest *request = [[HttpDnsRecordRequest alloc] initWithDelegate: self];
    request.tableName = tableName;
    request.host = host;
    [request startRequest: url postData: nil];
    
    DNSLog(@"request record: [%@]:[%@]", tableName, host);
}

#pragma mark - 网络回调
/***********************************
 网络Delegate
 ***********************************/

// 请求失败 --- Main thread
- (BOOL)requestErrored:(CRequestCommand *)requestCommand {
    if([requestCommand isKindOfClass: [HttpDnsWhitelistRequest class]]){
        self.dnsTable.isUpdating = NO;
        DNSLog(@"request whitelist: error");
    }else if([requestCommand isKindOfClass: [HttpDnsRecordRequest class]]){
        DNSLog(@"request record: error");
        HttpDnsRecordRequest *request = (HttpDnsRecordRequest*)requestCommand;
        // 将DNS记录状态改为Invalid
        [self updateAddress: nil forHost: request.host inTable: request.tableName];
    }
    return YES;
}

// 请求完成 --- Main thread
- (void)requestComplete:(CRequestCommand *)requestCommand {
    if([requestCommand isKindOfClass: [HttpDnsWhitelistRequest class]]){
        HttpDnsWhitelistRequest *request = (HttpDnsWhitelistRequest*)requestCommand;
        HttpDnsWhitelistModel *whitelistModel = (HttpDnsWhitelistModel*)request.responseModel;
        if(![whitelistModel isKindOfClass:[HttpDnsWhitelistModel class]]){
            self.dnsTable.isUpdating = NO;
            DNSLog(@"request whitelist: error");
            return;
        }
        DNSLog(@"request whitelist: success");
        // 更新白名单
        [self updateDnsTable:request.tableName withWhiteList: whitelistModel];
    }else if([requestCommand isKindOfClass: [HttpDnsRecordRequest class]]){
        HttpDnsRecordRequest *request = (HttpDnsRecordRequest*)requestCommand;
        if(request.ipArray && request.ipArray.count > 0){
            NSString *address = request.ipArray.firstObject;
            DNSLog(@"request record: success");
            // 更新DNS记录
            [self updateAddress: address forHost: request.host inTable: request.tableName];
        }else{
            DNSLog(@"request record: no available ip");
        }
    }
    return;
}

#pragma mark - 网络变化监听
/***********************************
 监听网络环境变化
 ***********************************/

// 开始监听
- (void)startObserveReachability {
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
}

// 停止监听
- (void)stopObserveReachability {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 生成当前网络环境下的表名
- (NSString*)generateDnsTableName:(NetworkStatus)reachableStatus {
    NSMutableString *newDnsTableName = [NSMutableString string];
    switch (reachableStatus) {
            // 蜂窝网络
        case ReachableViaWWAN:
        {
            [newDnsTableName appendString: @"WWAN-"];
            NSString *carrierName = [HttpDnsUtility getCarrierName];
            [newDnsTableName appendString: carrierName?carrierName:@"unknown"];
            [newDnsTableName appendString: @"-"];
            NSString *technology = [HttpDnsUtility getRadioAccessTechnology];
            [newDnsTableName appendString: technology?technology:@"unknown"];
        }
            break;
            // WiFi
        case ReachableViaWiFi:
        {
            [newDnsTableName appendString: @"WiFi-"];
            NSString *ssid = [HttpDnsUtility getWiFiSSID];
            [newDnsTableName appendString: ssid?ssid:@"unknown"];
        }
            break;
            // 无网络返回默认表名
        case NotReachable: default:
            [newDnsTableName appendString: HttpDnsDefaultTableName];
            break;
    }
    return newDnsTableName;
}

// 网络变化处理 --- Main thread
- (void) reachabilityChanged: (NSNotification* )notification {
    DNSLog(@"Network changed");
    // 生成新的DNS表名
    Reachability* curReach = [notification object];
    NetworkStatus reachableStatus = [curReach currentReachabilityStatus];
    NSString *newDnsTableName = [self generateDnsTableName: reachableStatus];
    // 更新表名
    [self changeDnsTableName: newDnsTableName];
}

#pragma mark - 持久化
/***********************************
 持久化
 ***********************************/

// 缓存目录
- (NSString*)cacheDirectory {
    NSString *path = [NSString stringWithFormat: @"%@/HttpDns/", [[CConfiguration sharedConfiguration] getPathByType: kPathForFileCache]];
    
    // 检查目录是否存在
    if(path && ![[NSFileManager defaultManager] fileExistsAtPath: path]){
        [[NSFileManager defaultManager] createDirectoryAtPath: path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
