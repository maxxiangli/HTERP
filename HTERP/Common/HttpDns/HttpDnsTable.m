//
//  HttpDnsTable.m
//  QQStock
//
//  Created by abelchen on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsTable.h"
#import "HttpDnsDebug.h"

/************************
 *  本地Http DNS记录
 ***********************/
@interface HttpDnsRecord()
- (NSDictionary*)toDictionary;
+ (HttpDnsRecord*)recordFromDictionary:(NSDictionary*)dictionary;
@end

@implementation HttpDnsRecord

- (instancetype)init {
    self = [super init];
    if(self){
        _ownerTableName = nil;
        _TTL = -1;
        _timestamp = 0;
        _host = nil;
        _address = nil;
        _isUpdating = NO;
        _isValid = NO;
        _version = 0;
    }
    return self;
}

- (void)dealloc {
     Safe_Release(_ownerTableName);
    Safe_Release(_host);
    Safe_Release(_address);
    
}

- (id)copyWithZone:(NSZone *)zone {
    HttpDnsRecord *newRecord = [[HttpDnsRecord allocWithZone:zone] init];
    newRecord.ownerTableName = self.ownerTableName;
    newRecord.TTL = self.TTL;
    newRecord.timestamp = self.timestamp;
    newRecord.host = self.host;
    newRecord.address = self.address;
    newRecord.isUpdating = self.isUpdating;
    newRecord.isValid = self.isValid;
    newRecord.version = self.version;
    return newRecord;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.ownerTableName){
        dictionary[@"ownerTableName"] = self.ownerTableName;
    }
    if(self.host){
        dictionary[@"host"] = self.host;
    }
    if(self.address){
        dictionary[@"address"] = self.address;
    }
    dictionary[@"TTL"]        = @(self.TTL);
    dictionary[@"timestamp"]  = @(self.timestamp);
    dictionary[@"isValid"]    = @(self.isValid);
    dictionary[@"version"]    = @(self.version);
    /* isUpdating不保存 */
    return dictionary;
}

+ (HttpDnsRecord *)recordFromDictionary:(NSDictionary*)dictionary {
    HttpDnsRecord *record = nil;
    if(dictionary){
        record = [[HttpDnsRecord alloc] init] ;
        record.ownerTableName = dictionary[@"ownerTableName"];
        record.host = dictionary[@"host"];
        record.address = dictionary[@"address"];
        record.TTL = [dictionary[@"TTL"] integerValue];
        record.timestamp = [dictionary[@"timestamp"] doubleValue];
        record.version = [dictionary[@"version"] integerValue];
        record.isValid = [dictionary[@"isValid"] boolValue];
        record.isUpdating = NO; // isUpdating调整为初始状态
    }
    return record;
}

- (NSString *)statusString {
    NSMutableString *str = [NSMutableString string];
    if(self.isValid){
        [str appendString: @"valid"];
    }else{
        [str appendString: @"invalid"];
    }
    if(self.isUpdating){
        if(str.length > 0) [str appendString: @"|"];
        [str appendString: @"updating"];
    }
    return str;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@:%@:%.0f:%ld:%@]", self.host, self.address, self.timestamp, (long)self.TTL, [self statusString]];
}

@end

/************************
 *  本地Http DNS记录管理表
 ***********************/
@interface HttpDnsTable()
@property (nonatomic, retain) NSMutableDictionary<NSString*,HttpDnsRecord*> *recordsDict;
@end

@implementation HttpDnsTable

- (instancetype)init {
    self = [super init];
    if(self){
        _name = HttpDnsDefaultTableName;
        _dnsip = nil;
        _isUpdating = NO;
        // 创建空表
        _recordsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    Safe_Release(_name);
    Safe_Release(_dnsip);
    Safe_Release(_recordsDict);
    
}

- (id)copyWithZone:(NSZone *)zone {
    HttpDnsTable *newTable = [[HttpDnsTable allocWithZone: zone] init];
    newTable.name = self.name;
    newTable.dnsip = self.dnsip;
    newTable.isUpdating = self.isUpdating;
    newTable.recordsDict = [NSMutableDictionary dictionary];
    for(NSString *host in self.recordsDict){
        newTable.recordsDict[host] = [self.recordsDict[host] copy];
    }
    return newTable;
}

- (NSString *)description {
    NSMutableString *recordStr = [NSMutableString string];
    for(NSString *host in self.recordsDict){
        [recordStr appendFormat: @"\t%@\n", self.recordsDict[host]];
    }
    return [NSString stringWithFormat:@"\nname: %@:\ndnsip: %@\nrecords: {\n%@}\n", self.name, self.dnsip, recordStr];
}

// 将表名做md5，用于存储文件名
- (NSString*)md5TableName {
    return [CMD5Util md5String: self.name];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.name){
        dictionary[@"name"] = self.name;
    }
    if(self.dnsip){
        dictionary[@"dnsip"] = self.dnsip;
    }
    /* isUpdating不保存 */
    
    if(self.recordsDict){
        NSMutableDictionary *recordsDict = [NSMutableDictionary dictionary];
        dictionary[@"recordsDict"] = recordsDict;
        for(NSString *host in self.recordsDict){
            HttpDnsRecord *record = self.recordsDict[host];
            NSDictionary *recDict = [record toDictionary];
            if(recDict){
                recordsDict[host] = recDict;
            }
            
        }
    }
    return dictionary;
}

// 根据当前name从文件缓存中读取保存的DNS表
- (void)loadFromCache:(NSString*)cachePath {
    // 清除当前记录
    [self.recordsDict removeAllObjects];
    self.dnsip = nil;
    self.isUpdating = NO;
    // 默认表是空表
    if([self.name isEqualToString: HttpDnsDefaultTableName]){
        DNSLog(@"load table: default table");
        return;
    }
    // 读取缓存记录
    NSString *filename = self.md5TableName;
    if(!filename){
        DNSLog(@"load table: invalid name [%@]:[%@]", self.name, filename);
        return;
    }
    if(!cachePath){
        DNSLog(@"load table: invalid path [%@]:[%@]", self.name, cachePath);
        return;
    }
    filename = [cachePath stringByAppendingString: filename]; // 生成路径
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile: filename];
    if(!dataDict){
        DNSLog(@"load table: invalid file data [%@]:[%@]", self.name, filename);
        return;
    }
    // 解析数据
    self.dnsip = dataDict[@"dnsip"];
    self.isUpdating = NO; // isUpdating调整为初始状态
    NSDictionary *recordsDict = dataDict[@"recordsDict"];
    if(recordsDict){
        for(NSString *host in recordsDict){
            HttpDnsRecord *record = [HttpDnsRecord recordFromDictionary: recordsDict[host]];
            if(record){
                [self.recordsDict setObject: record forKey: host];
                DNSLog(@"load table: set record %@", record);
            }
        }
    }
    DNSLog(@"load table: %@", self);
}

// 根据当前name将DNS表保存到文件缓存
- (void)saveToCache:(NSString*)cachePath {
    // 默认表是空表，不保存
    if([self.name isEqualToString: HttpDnsDefaultTableName]){
        DNSLog(@"save table: default table");
        return;
    }
    NSString *filename = self.md5TableName;
    if(!filename){
        DNSLog(@"save table: invalid name [%@]:[%@]", self.name, filename);
        return;
    }
    if(!cachePath){
        DNSLog(@"save table: invalid path [%@]:[%@]", self.name, cachePath);
        return;
    }
    filename = [cachePath stringByAppendingString: filename]; // 生成路径
    // 表数据转换成字典
    NSDictionary *tableDict = [self toDictionary];
    // 写文件缓存
    if([tableDict writeToFile: filename atomically: YES]){
        DNSLog(@"save table: %@", self);
    }else{
        DNSLog(@"save table: write file error [%@]:[%@]", self.name, filename);
    }
}

@end
