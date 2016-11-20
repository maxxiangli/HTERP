//
//  HTLoginManager.h
//  HTERP
//
//  Created by li xiang on 16/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLoginInforModel.h"

FOUNDATION_EXPORT NSString *const kHTLoginSession;
FOUNDATION_EXPORT NSString *const kHTLoginUserId;
FOUNDATION_EXPORT NSString *const kHTIMToken;

@interface HTLoginManager : NSObject
@property(nonatomic, strong) CLoginInforModel *loginInfor;

+ (HTLoginManager *)getInstance;

- (NSString *)uin;
- (BOOL)isLogin;
- (void)loadLoginData;
- (void)saveLoginData:(CLoginInforModel *)loginInfor;
@end
