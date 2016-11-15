 //
//  HTLoginManager.m
//  HTERP
//
//  Created by li xiang on 16/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

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
    //自动归档
    
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
