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

@interface CHRCIMDataSource : NSObject

+ (instancetype)sharedRCIMDataSource;

//配置融云
- (void)configRCIM;

//配置融云Delegate
- (void)configRCIMDelegate;

@end
