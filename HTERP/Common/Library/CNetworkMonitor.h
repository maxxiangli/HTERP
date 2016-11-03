//
//  CNetworkMonitor.h
//  QQStock
//
//  Created by suning wang on 12-2-15.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

enum 
{
	eNetworkNETUnknown = -1,
	eNetworkNETNone = 0,		//无网络
	eNetworkNETwifi,
	eNetworkNETwwan
};
typedef NSInteger TNetworkType;

@interface CNetworkMonitor : NSObject
{
}

@property (nonatomic,readonly) TNetworkType networkType;
@property (atomic,retain) NSString * cellType;

+ (CNetworkMonitor*) sharedNetworkMonitor;
+ (void) purgeSharedNetworkMonitor;

- (void) start:(float)delay;
- (void) start;
- (BOOL) isStarting;
- (void) stop;

@end

extern NSString *const kNetworkTypeNotificationKey;
