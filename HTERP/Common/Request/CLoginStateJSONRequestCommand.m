//
//  CLoginStateJSONRequestCommand.m
//  QQStock
//
//  Created by zheliang on 15/7/10.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CLoginStateJSONRequestCommand.h"
#import "CLoginInforModel.h"
#import "HTLoginManager.h"

@implementation CLoginStateJSONRequestCommand
- (BOOL) urlDataLoadAuthentication:(CURLDataLoader*)loader trustServer:(NSString*)host
{
    return NO;
}

- (void)startRequest:(NSString *)url postData:(NSDictionary *)postData
{
    [self setTimeOutSeconds:20];
    NSString* newUrl = [self setUpUrlParam:url];
    Info(@"URL:%@",newUrl);
    [super startRequest:newUrl postData:postData];
    
}

- (void) startRequest:(NSString*)inputUrl postData:(NSDictionary*)postData header:(NSDictionary*)header
{
    [self setTimeOutSeconds:20];
    NSString* newUrl = [self setUpUrlParam:inputUrl];
    Info(@"URL:%@",newUrl);
    [super startRequest:newUrl postData:postData header:[self setUpHeader]];
}

//登录态信息
-(NSString *)setUpUrlParam:(NSString *)url
{
    
//    NSString *loginTypeStr = nil;;
//    
////    if ( EloginTypeWx == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
////    {
////        loginTypeStr = @"6";
////    }
////    else if ( eLoginTypeWT == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
////    {
////        loginTypeStr = @"2";
////    }
////    else
////    {
////        loginTypeStr = @"1";
////    }
//    NSMutableString *reqUrl = nil;
//    NSRange range = [url rangeOfString:@"?"];
//    if (range.length != 0) {
//        reqUrl = [NSMutableString stringWithFormat:@"%@&check=%@&app=3G",url,loginTypeStr];
//    }
//    else
//    {
//        reqUrl = [NSMutableString stringWithFormat:@"%@?check=%@&app=3G",url,loginTypeStr];
//    }
//    
////    if ( EloginTypeWx == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
////    {
////        [reqUrl appendString:[NSString stringWithFormat:@"&openid=%@&token=%@&appid=%@",  GLOBEL_LOGIN_OBJECT.openId, GLOBEL_LOGIN_OBJECT.userLoginCookie, WXAPIID]];
////    }
////#warning 测试环境
////    [reqUrl appendString:[NSString stringWithFormat:@"&_appName=%@",@"phpTest"]];
//    
    return url;
}

- (NSDictionary *)setUpHeader
{
    CLoginInforModel *loginInfo = [HTLoginManager getInstance].loginInfor;
    NSString *luin = (loginInfo.uin && [loginInfo.uin length] > 0) ? loginInfo.uin : @"1479369785138084301";
    NSString *lskey = (loginInfo.session && [loginInfo.session length] > 0) ? loginInfo.session : @"test";
    
    NSString *cookieStr = [NSString stringWithFormat:@"luin:%@;lskey:%@",luin,lskey];;
    NSString *ecodeCookieStr = [cookieStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!ecodeCookieStr)
    {
        ecodeCookieStr = @"";
    }
    
    NSDictionary *header = [NSDictionary dictionaryWithObject:ecodeCookieStr forKey:@"Cookie"];
    NSLog(@"hearder = %@", header);
    return header;
}

@end
