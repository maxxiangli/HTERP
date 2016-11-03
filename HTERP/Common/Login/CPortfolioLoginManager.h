//
//  CPortfolioLoginManager.h
//  QQStock_lixiang
//
//  Created by xiang li on 14-1-7.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPortfolioLoginManager : NSObject<CRequestDelegate>
{
    
}
@property(nonatomic, assign, readonly) BOOL isPortFolioLogin;//自选列表是否登录
@property(nonatomic, assign, readonly) BOOL isStockMomentsLogin;//股票圈是否登录
@property(nonatomic, assign, readonly) BOOL isQQShareLogin;//分享是否登录（不包含sina）


@property(nonatomic, copy) NSString *nickName;//wt:昵称 wx：昵称
@property(nonatomic, copy) NSString *openId;//wt:nil wx：openid
@property(nonatomic, copy) NSString *userLoginUin;//wt:qq号 wx：qq号
@property(nonatomic, copy) NSString *userLoginCookie;//wt:cookie wx:access_token
@property(nonatomic, copy) NSString *userLoginSkeyCookie;//wt:lskey_cookie
@property(nonatomic, copy) NSString *headeUrl;//wt:url wx：url
@property(nonatomic, copy) NSString *portfolioLoginTypeStr;//2 3 6 为了兼容qq和微信登录提供该接口，慎用


@property(nonatomic, copy) NSString *wxnickName;//wt:昵称 wx：昵称
@property(nonatomic, copy) NSString *wxopenId;//wt:后台分配 wx：openid
@property(nonatomic, copy) NSString *gOpenId;//wt:后台分配 wx：后台分配
@property(nonatomic, copy) NSString *wxuserLoginUin;//wt:qq号 wx：qq号
@property(nonatomic, copy) NSString *wxToken;//wt:nil wx:access_token



@property(nonatomic, copy) NSString *shareuserLoginCookie;//wt:cookie wx:access_token
@property(nonatomic, copy) NSString *shareuserLoginSkeyCookie;//wt:lskey_cookie wx:nil


+ (CPortfolioLoginManager *)getInstance;
@end
