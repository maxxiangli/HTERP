//
//  HttpDnsUtility.m
//  QQStock
//
//  Created by abelchen on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "HttpDnsUtility.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation HttpDnsUtility

// 判断IP是否合法
+ (BOOL)isValidIP:(NSString*)ip {
    // 获取4个分段数据
    NSArray *parts = [ip componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    // 判断每个数字范围
    BOOL isValidIp = NO;
    if(parts && parts.count == 4){
        isValidIp = YES;
        for(NSString *num in parts){
            NSInteger value = num.integerValue;
            if(value < 0 || value > 255){
                isValidIp = NO;
                break;
            }
        }
    }
    return isValidIp;
}

+ (NSString*)getWiFiSSID {
    NSArray *interfaces = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *ssid = nil;
    for(NSString *name in interfaces){
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)name));
        if(info){
            ssid = [info objectForKey: (NSString*)kCNNetworkInfoKeySSID] ;
            
            break;
        }
        
    }
    
    return ssid;
}

+ (NSString*)getCarrierName {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = netInfo.subscriberCellularProvider;
    NSString *name = carrier.carrierName  ;
    
    return name;
}

+ (NSString*)getRadioAccessTechnology {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *type = netInfo.currentRadioAccessTechnology  ;
    
    return type;
}

@end
