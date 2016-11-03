//
//  CAppThemeManager.h
//  QQStock
//
//  Created by ZHANG Tianle on 4/5/12.
//  Copyright (c) 2012 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 主题切换Notification
#define KAppThemeChangedNotification          @"AppThemeChangedNotification"

@interface CThemeManager : NSObject

+(CThemeManager*) sharedThemeManager;
+(void) purgeSharedThemeManager;

- (void) pushThemeChangedNotification;

- (UIImage*) getBundleImageUnderTheme:(NSString*)imageName;
- (UIColor*) getColorUnderTheme:(NSString*)colorName;
@end
