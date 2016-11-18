 //
//  HTLoginManager.m
//  HTERP
//
//  Created by li xiang on 16/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//


NSString *const kHTLoginSession = @"HTLoginSession";
NSString *const kHTLoginUserId = @"HTLoginUserId";
NSString *const kHTIMToken = @"HTIMToken";

#import "HTLoginManager.h"

@implementation HTLoginManager

- (NSString *)uin
{
    return self.loginInfor.uin;
}

- (BOOL)isLogin
{
    return self.loginInfor.session ? YES : NO;
}

- (void)loadLoginData
{
    
}

- (void)saveLoginData:(CLoginInforModel *)loginInfor
{
    self.loginInfor = loginInfor;
    
    //自动归档(暂且使用NSUserDefault)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.loginInfor.userId && [self.loginInfor.userId length] > 0)
    {
        [userDefaults setObject:self.loginInfor.userId forKey:kHTLoginUserId];
    }
    
    if (self.loginInfor.session && [self.loginInfor.session length])
    {
        [userDefaults setObject:self.loginInfor.session forKey:kHTLoginSession];
    }
    
    if (self.loginInfor.token && [self.loginInfor.token length] > 0)
    {
        [userDefaults setObject:self.loginInfor.token forKey:kHTIMToken];
    }
    
    [userDefaults synchronize];
}


+ (HTLoginManager *)getInstance
{
    static HTLoginManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTLoginManager alloc] init];
    });
    
    return manager;
}
@end
