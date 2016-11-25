//
//  GJGCRecentChatDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatDataManager.h"
#import "GJGCRecentChatStyle.h"
#import "GJGCChatFriendCellStyle.h"
#import "GJGCMessageExtendModel.h"
#import "ZYUserCenter.h"

#import "HTLoginManager.h"
#import "CHRCIMDataSource.h"

#import <RongIMLib/RongIMLib.h>

#define GJGCRecentConversationNicknameListUDF @"GJGCRecentConversationNicknameListUDF"

#define GJGCRecentConversationHeadListUDF @"GJGCRecentConversationHeadListUDF"


@interface GJGCRecentChatDataManager ()

@property (nonatomic,strong)NSMutableArray *sourceArray;

@property (nonatomic,strong)dispatch_source_t updateListSource;

@end

@implementation GJGCRecentChatDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        //缓冲更新队列
        self.updateListSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
        GJCFWeakSelf weakSelf = self;
        dispatch_source_set_event_handler(self.updateListSource, ^{
            
            [weakSelf conversationListUpdate];
            
        });
        dispatch_resume(self.updateListSource);
        
        self.sourceArray = [[NSMutableArray alloc] init];
        
        [[CHRCIMDataSource sharedRCIMDataSource] configRCIMDelegate];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleConnectionStatusChanged:)
                                                     name:CHRCIMConnectionStatsChangedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleReceiveMessage:)
                                                     name:CHRCIMReceiveMessageNotification
                                                   object:nil];
        


    }
    return self;
}

- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)allConversationModels
{
    return self.sourceArray;
}

- (NSInteger)totalCount
{
    return self.sourceArray.count;
}

- (GJGCRecentChatModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row > self.sourceArray.count - 1) {
        return nil;
    }
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (CGFloat)contentHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (void)deleteConversationAtIndexPath:(NSIndexPath *)indexPath
{
    GJGCRecentChatModel *chatModel = [self contentModelAtIndexPath:indexPath];
    
    //TODO:WXT(为了测试暂时不删除)
    [[RCIMClient sharedRCIMClient] removeConversation:chatModel.conversation.conversationType
                                             targetId:chatModel.conversation.targetId];
    
    [self.sourceArray removeObject:chatModel];

    [self.delegate dataManagerRequireRefresh:self requireDeletePaths:@[indexPath]];
}

- (void)loadRecentConversations
{
    RCConnectionStatus state = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    NSLog(@"connection state = %@", @(state));
    BOOL isLogin = [[HTLoginManager getInstance] isLogin];
    isLogin = YES;
    if (isLogin && state == ConnectionStatus_Connected)
    {
        NSArray *allConversation = [self getConversations];
        [self didUpdateConversationList:allConversation];
    }
}

- (NSString *)displayContentFromConversation:(RCConversation *)theConversation
{
    NSString *result = nil;
    NSString *objectName = theConversation.objectName;
    if ([objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        RCTextMessage *textMessage = (RCTextMessage *)theConversation.lastestMessage;
        result = textMessage.content;
    }
    else if ([objectName isEqualToString:RCVoiceMessageTypeIdentifier])
    {
        result = @"[语音]";
    }
    else if([objectName isEqualToString:RCImageMessageTypeIdentifier])
    {
        result = @"[图片]";
    }
    else if([objectName isEqualToString:RCFileMessageTypeIdentifier])
    {
        result = @"[文件]";
    }else{
        result = @"[未知]";
    }
    return result;
}

#pragma mark - Private function
- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    if (aConversationList.count > 0) {
        [self updateConversationList:aConversationList];
    }
}

- (NSArray *)getConversations
{
    NSArray *types = @[@(ConversationType_PRIVATE),
                       @(ConversationType_DISCUSSION),
                       @(ConversationType_APPSERVICE),
                       @(ConversationType_PUBLICSERVICE),
                       @(ConversationType_GROUP),
                       @(ConversationType_SYSTEM)];
    
    NSArray *allConversations = [[RCIMClient sharedRCIMClient] getConversationList:types];
    
    return allConversations;
}


#pragma mark - 更新列表
- (void)updateConversationList:(NSArray *)conversationList
{
    
    NSLog(@"conversation count = %@", @([conversationList count]));
    
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (conversationList.count == 0)
            {
                return;
            }
    
            //重新载入一次会话列表
            if (self.sourceArray.count > 0)
            {
                [self.sourceArray removeAllObjects];
            }
    
            //按最后一条消息排序
            NSArray *sortConversationList = [conversationList sortedArrayUsingComparator:^NSComparisonResult(RCConversation *obj1, RCConversation *obj2) {
    
                long long time1 = [[RCIMClient sharedRCIMClient] getMessageSendTime:obj1.lastestMessageId];
                long long time2 = [[RCIMClient sharedRCIMClient] getMessageSendTime:obj2.lastestMessageId];
                
                NSComparisonResult result = (time1 > time2) ? NSOrderedAscending : NSOrderedDescending;
                return result;
    
            }];
    
            for (RCConversation *conversation in sortConversationList)
            {
                GJGCRecentChatModel *chatModel = [[GJGCRecentChatModel alloc] init];
                chatModel.conversation = conversation;
                chatModel.toId = conversation.targetId;
                chatModel.unReadCount = conversation.unreadMessageCount;
                
                NSString *name = conversation.conversationTitle;
                name = (name && [name length] > 0) ? name : @"群聊";
                chatModel.name = [GJGCRecentChatStyle formateName:name];
                
                RCMessageDirection direction = conversation.lastestMessageDirection;
                
                long long timeStamp = (direction == MessageDirection_SEND) ? conversation.sentTime : conversation.receivedTime;
                chatModel.content = [self displayContentFromConversation:conversation];
                [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];

                chatModel.time = [GJGCRecentChatStyle formateTime:timeStamp/1000];
                [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
                
                if (conversation.conversationType == ConversationType_GROUP)
                {
                    chatModel.isGroupChat = YES;
                    if (conversation.lastestMessage)
                    {
                        chatModel.headUrl = conversation.lastestMessage.senderUserInfo.portraitUri;
                        chatModel.groupInfo = nil;
                    }
                }
    
                if (conversation.conversationType == ConversationType_PRIVATE)
                {
                    //对方的最近一条消息
                    chatModel.isGroupChat = NO;
                    RCMessageContent *lastMessage = conversation.lastestMessage;
                    if (lastMessage)
                    {
                        NSString *name = lastMessage.senderUserInfo.name ? lastMessage.senderUserInfo.name : conversation.targetId;
                        chatModel.name = [GJGCRecentChatStyle formateName:name];
                        chatModel.headUrl = lastMessage.senderUserInfo.portraitUri;
    
                    }
                    else
                    {
                        chatModel.name = [GJGCRecentChatStyle formateName:conversation.targetId];
                        chatModel.headUrl = @"";
                    }
                }
                
                [self.sourceArray addObject:chatModel];
            }
    
            dispatch_source_merge_data(self.updateListSource, 1);
            
        });
}

- (void)conversationListUpdate
{
    [self.delegate dataManagerRequireRefresh:self];
}

- (void)saveUser:(NSString *)userId nickname:(NSString *)nickname headUrl:(NSString *)headUrl
{
    
}

#pragma mark - 监听网络变化，未登录尝试重新登录
- (void)handleConnectionStatusChanged:(NSNotification *)notifcation
{
    NSNumber *objStatus = (NSNumber *)notifcation.object;
    RCConnectionStatus status = [objStatus integerValue];
    
    if (status == ConnectionStatus_Connected)
    {
        //如果用户未登录重新登录
    }
    
    switch (status)
    {
        case ConnectionStatus_Connected:
            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateSuccess];
            [self loadRecentConversations];
            break;
        case ConnectionStatus_Connecting:
            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateConnecting];
            break;
        case ConnectionStatus_Unconnected:
        case ConnectionStatus_SignUp: //已注销
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT: //Token错误
            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateFaild];
            break;
        default:
            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateConnecting];
            break;
    }
}

#pragma mark - 监控收到新消息
- (void)handleReceiveMessage:(NSNotification *)notification
{
    [self loadRecentConversations];
}

#pragma mark - 检测会话是否已经存在
+ (BOOL)isConversationHasBeenExist:(NSString *)chatter
{
    NSArray *types = @[@(ConversationType_PRIVATE),
                       @(ConversationType_DISCUSSION),
                       @(ConversationType_APPSERVICE),
                       @(ConversationType_PUBLICSERVICE),
                       @(ConversationType_GROUP),
                       @(ConversationType_SYSTEM)];
    
    NSArray *allConversation = [[RCIMClient sharedRCIMClient] getConversationList:types];
    
    BOOL find = NO;
    for (RCConversation *conversation in allConversation)
    {
        if ([conversation.targetId isEqualToString:chatter])
        {
            find = YES;
            break;
        }
    }
    
    return find;
}

#pragma mark - Discard
//- (NSString *)displayContentFromMessageBody:(RCMessageContent *)theMessage
//{
//    NSString *result = nil;
//    NSString *identifier = [RCMessageContent getObjectName];
//    if ([identifier isEqualToString:RCTextMessageTypeIdentifier])
//    {
//        RCTextMessage *textMessage = (RCTextMessage *)theMessage;
//        result = textMessage.content;
//    }
//    else if ([identifier isEqualToString:RCVoiceMessageTypeIdentifier])
//    {
//        result = @"[语音]";
//    }
//    else if([identifier isEqualToString:RCImageMessageTypeIdentifier])
//    {
//        result = @"[图片]";
//    }
//    else
//    {
//        //Do nothing
//    }
//    return result;
//}


@end
