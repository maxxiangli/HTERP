//
//  HTGlobal.m
//  HTERP
//
//  Created by li xiang on 16/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "HTGlobal.h"

//以下为发布APPSTORE,千万不要更改，更改后果自负
//以下为发布APPSTORE,千万不要更改，更改后果自负
//以下为发布APPSTORE,千万不要更改，更改后果自负
//以下为发布APPSTORE,千万不要更改，更改后果自负

#ifdef APPSTORE_PROFILE
int  TEST_HUSHEN_TRADE      = 0;//沪深交易
int  TEST_Competition_TRADE = 0;//A股大赛
int  TEST_SERVER_REMOTECTRL = 0;//远程控制
int  STOCKTOPIC_TEST_SERVER = 0;//股票圈测试地址
int  STOCKTOPIC_FAKE_SERVER = 0;//股票圈伪测试地址
int  TEST_HK_NEW_TRADER     = 0;//港股交易UI
int  TEST_HK_Trade_Server   = 0;//港股交易券商地址
int  TEST_SMARTBOX_SEARCH   = 0;//smartbox搜索
int  TEST_CALENDER          = 0;//新股日历
int  TEST_HangQing          = 0;//行情=======
int  DISABLE_HTTPDNS        = 0;//HttpDns 1表示关闭，0表示打开
////以上为发布APPSTORE用,千万不要更改，更改后果自负
////以上为发布APPSTORE用,千万不要更改，更改后果自负
////以上为发布APPSTORE用,千万不要更改，更改后果自负
////以上为发布APPSTORE用,千万不要更改，更改后果自负

#else
//Debug、RDM请修改此处
int  TEST_HUSHEN_TRADE      = 0;//沪深交易
int  TEST_Competition_TRADE = 0;//A股大赛
int  TEST_SERVER_REMOTECTRL = 0;//远程控制
int  STOCKTOPIC_TEST_SERVER = 0;//股票圈测试地址
int  STOCKTOPIC_FAKE_SERVER = 0;//股票圈伪测试地址
int  TEST_HK_NEW_TRADER     = 0;//港股交易UI
int  TEST_HK_Trade_Server   = 0;//港股交易券商地址
int  TEST_SMARTBOX_SEARCH   = 0;//smartbox搜索
int  TEST_CALENDER          = 0;//新股日历
int  TEST_HangQing          = 0;//行情=======

#if TARGET_IPHONE_SIMULATOR
int  DISABLE_HTTPDNS        = 1;//HttpDns 1表示关闭，0表示打开, 模拟器下关闭 否则登录无法获取个人信息
#else
int  DISABLE_HTTPDNS        = 0;//HttpDns 1表示关闭，0表示打开
#endif

#endif
