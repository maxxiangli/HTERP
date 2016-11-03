//
//  HttpDnsUtility.h
//  QQStock
//
//  Created by abelchen on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDnsDebug.h"

@interface HttpDnsUtility : NSObject

// 判断IP是否合法
+ (BOOL)isValidIP:(NSString*)ip;

// 返回WiFi网络的SSID
+ (NSString*)getWiFiSSID;
// 返回蜂窝网络的技术类型
+ (NSString*)getRadioAccessTechnology;
// 返回运营商名
+ (NSString*)getCarrierName;

@end