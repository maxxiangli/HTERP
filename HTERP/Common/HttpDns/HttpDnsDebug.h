//
//  HttpDnsDebug.h
//  QQStock
//
//  Created by abelchen on 15/11/13.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDnsManager.h"

//#define HTTP_DNS_DEBUG

#define HttpDnsTableChangedNotification @"HttpDnsTableChangedNotification"
#define HttpDnsTableLogNotification     @"HttpDnsTableLogNotification"

#ifdef HTTP_DNS_DEBUG

    #define DNSLog(fmt,...) {\
        NSLog(@"HttpDns > " fmt, ##__VA_ARGS__);\
        NSString *logStr = [NSString stringWithFormat: @"> "fmt, ##__VA_ARGS__];\
        dispatch_async(dispatch_get_main_queue(), ^(){\
            [[NSNotificationCenter defaultCenter] postNotificationName: HttpDnsTableLogNotification object: logStr];\
        });\
    }
    uint64_t dispatch_benchmark(size_t count, void(^block)(void));
    #define BENCHMARK_START(msg) {NSString *message = msg; double time = dispatch_benchmark(1, ^(){
    #define BENCHMARK_END }) / 1000000.0; DNSLog(@"%@: %f ms", message, time);}

    // Dns表改变通知，用于调试
    #define HttpDnsNotifyChanged dispatch_async(dispatch_get_main_queue(), ^(){\
        [[NSNotificationCenter defaultCenter] postNotificationName: HttpDnsTableChangedNotification object:nil];\
    });

@interface HttpDnsDebug : UIViewController

+ (HttpDnsDebug*)sharedDebugController;

@end

#else

    #define DNSLog(fmt,...)
    #define BENCHMARK_START(x)
    #define BENCHMARK_END

    #define HttpDnsNotifyChanged

#endif
