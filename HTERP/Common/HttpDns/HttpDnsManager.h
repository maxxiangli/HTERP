//
//  HttpDnsManager.h
//  QQStock
//
//  Created by abelchen on 15/11/16.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDnsTable.h"
#import "HttpDnsDebug.h"

@interface HttpDnsManager : NSObject

// 单例
+ (HttpDnsManager*)sharedManager;

// 启用或禁用
@property (nonatomic, assign) BOOL enabled;

// 读取host的dns记录
- (HttpDnsRecord*)recordForHost:(NSString*)host;
// 使host对应dns记录失效
- (void)invalidateRecord:(HttpDnsRecord*)record;

// 触发白名单更新
- (void)updateWhiteList;
// 将数据刷回缓存
- (void)flushBackTableCache;

@end

/** 想要知道工程中哪些地方插入了HttpDns，全局搜索HttpDns即可 **/
/* 主要改动了CRequestCommand、AppDelegate、CSettingsController */

////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| O_O |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑       永无BUG     永不修改                       //
////////////////////////////////////////////////////////////////////
