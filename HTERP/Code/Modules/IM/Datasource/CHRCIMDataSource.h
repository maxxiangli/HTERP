//
//  CHRCIMDataSource.h
//  HTERP
//
//  Created by macbook on 20/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RongIMLib/RongIMLib.h>

FOUNDATION_EXPORT NSString *const CHRCIMConnectionStatsChangedNotification;
FOUNDATION_EXPORT NSString *const CHRCIMReceiveMessageNotification;
FOUNDATION_EXPORT NSString *const CHRCIMRCMessageKey;
FOUNDATION_EXPORT NSString *const CHRCIMLeftMessageKey;

@interface CHRCIMDataSource : NSObject

+ (instancetype)sharedRCIMDataSource;

//配置融云
- (void)configRCIM;

//配置融云Delegate
- (void)configRCIMDelegate;

@end
