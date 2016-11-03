//
//  HttpDnsWhitelistRequest.m
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsWhitelistRequest.h"

@implementation HttpDnsWhitelistRequest

- (void)dealloc {
    Safe_Release(_tableName);
    
}

@end

@implementation HttpDnsWhitelistItemModel

- (void)dealloc {
    Safe_Release(_domain);
    
}

@end

@implementation HttpDnsWhitelistModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data.dnsip":@"dnsip",
                                                        @"data.domains":@"domains"}];
}

- (void)dealloc {
    Safe_Release(_dnsip);
    Safe_Release(_domains);
    
}

@end

@implementation HttpDnsWhitelistParams

+ (NSString *)serverAddress {
    return @"http://ifzq.gtimg.cn/";
}

+ (NSString *)path {
    return @"appstock/httpdns/domain/whitelist";
}

@end
