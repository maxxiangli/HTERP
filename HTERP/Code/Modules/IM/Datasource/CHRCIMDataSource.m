//
//  CHRCIMDataSource.m
//  HTERP
//
//  Created by macbook on 20/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHRCIMDataSource.h"
#import "HTLoginManager.h"
#import "CHCreateGroupParam.h"
#import "CHCreateGroupModel.h"
#import "CLoginStateJSONRequestCommand.h"

//融云APPKey
static NSString *const kCHIMAppKey = @"82hegw5uhgzrx";

//融云连接状态变化消息
NSString *const CHRCIMConnectionStatsChangedNotification = @"CHRCIMConnectionStatsChangedNotification";
NSString *const CHRCIMReceiveMessageNotification = @"CHRCIMReceiveMessageNotification";
NSString *const CHRCIMRCMessageKey = @"CHRCIMRCMessageKey";
NSString *const CHRCIMLeftMessageKey = @"CHRCIMLeftMessageKey";

@interface CHRCIMDataSource()<RCConnectionStatusChangeDelegate, RCIMClientReceiveMessageDelegate>

@end

@implementation CHRCIMDataSource

+ (instancetype)sharedRCIMDataSource
{
    static CHRCIMDataSource *dataSource = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[CHRCIMDataSource alloc] init];
    });
    
    return dataSource;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //Do nothing
    }
    return self;
}


//初始化融云
- (void)configRCIM
{
    //初始化SDK
    [[RCIMClient sharedRCIMClient] initWithAppKey:kCHIMAppKey];
    
    //连接服务器
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kHTIMToken];
    [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
        
        NSLog(@"连接融云成功:%@", userId);
        
    } error:^(RCConnectErrorCode status){
        
        NSLog(@"连接融云错误:%@", @(status));
        
    } tokenIncorrect:^{
        
        NSLog(@"Token 错误");
        
    }];
}

- (void)configRCIMDelegate
{
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
}

#pragma mark - RCConnectionStatusChangeDelegate

//IMLib连接状态的的监听器
- (void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *objStatus = @(status);
        [[NSNotificationCenter defaultCenter] postNotificationName:CHRCIMConnectionStatsChangedNotification
                                                            object:objStatus];
    });
}

#pragma mark - RCIMClientReceiveMessageDelegate

//接收消息的回调方法
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *userInfo = @{CHRCIMRCMessageKey:message,
                                   CHRCIMLeftMessageKey:@(nLeft)};
        [[NSNotificationCenter defaultCenter] postNotificationName:CHRCIMReceiveMessageNotification
                                                            object:nil userInfo:userInfo];
    });
}

//消息被撤回的回调方法
- (void)onMessageRecalled:(long)messageId
{
    
}

//请求消息已读回执
- (void)onMessageReceiptRequest:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                     messageUId:(NSString *)messageUId
{
    
}


//消息已读回执响应（收到阅读回执响应，可以按照 messageUId 更新消息的阅读数）
- (void)onMessageReceiptResponse:(RCConversationType)conversationType
                        targetId:(NSString *)targetId
                      messageUId:(NSString *)messageUId
                      readerList:(NSMutableDictionary *)userIdList
{
    
}

#pragma mark - Public function
- (void)createChatRoom:(NSString *)roomName users:(NSArray *)users
{
    if (!roomName || [roomName length] == 0)
    {
        return;
    }
    
    if (!users || [users count] <= 2)
    {
        return;
    }
    
    NSUInteger count = [users count];
    NSMutableString *strUsers = [NSMutableString stringWithCapacity:128];
    for (NSUInteger i = 0; i < count; i++)
    {
        NSString *content = (i != 0) ? [NSString stringWithFormat:@",%@",users[i]] : users[i];
        [strUsers appendString:content];
    }
    
    CHCreateGroupParam *getParam = [[CHCreateGroupParam alloc] init];
    getParam.userId = @"1479369785138084301";//[HTLoginManager getInstance].loginInfor.userId;
    
    NSDictionary *postParam = @{@"name":roomName, @"userIds":strUsers};
    
    [CLoginStateJSONRequestCommand getWithParams:getParam modelClass:[CHCreateGroupModel class] postOtherParams:postParam header:nil sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        
        CHCreateGroupModel *groupModel = (CHCreateGroupModel *)requestCommand.responseModel;
        NSLog(@"groupModel = %@", groupModel.groupId);
        
    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        
        NSLog(@"msg==========");
        
    }];
}





@end
