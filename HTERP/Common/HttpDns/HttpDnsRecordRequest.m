//
//  HttpDnsRecordRequest.m
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsRecordRequest.h"
#import "HttpDnsManager.h"
#import "HttpDnsUtility.h"

@implementation HttpDnsRecordRequest

- (void)dealloc {
    Safe_Release(_tableName);
    Safe_Release(_host);
    Safe_Release(_ipArray);
    
}

- (void)parserDataInThread:(NSData *)recvData {
    NSString *strData = [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
    DNSLog(@"receive record: [%@]", strData);
    if(!strData) return;
    NSArray *ips = [strData componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]];
    NSMutableArray *ipArray = [NSMutableArray array];
    for(NSString *ip in ips){
        if([HttpDnsUtility isValidIP:ip]){
            [ipArray addObject: ip];
            DNSLog(@"parse ip: [%@]", ip);
        }else{
            DNSLog(@"parse ip: invalid [%@]", ip);
        }
    }
    self.ipArray = ipArray;
    
}

@end
