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

#import <RongIMLib/RongIMLib.h>

#define GJGCRecentConversationNicknameListUDF @"GJGCRecentConversationNicknameListUDF"

#define GJGCRecentConversationHeadListUDF @"GJGCRecentConversationHeadListUDF"


@interface GJGCRecentChatDataManager ()<RCConnectionStatusChangeDelegate, RCIMClientReceiveMessageDelegate>

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
        
        self.sourceArray = [[NSMutableArray alloc]init];
        
        [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
        
        [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
        
        [GJCFNotificationCenter addObserver:self
                                   selector:@selector(observeLoginSuccess:)
                                       name:ZYUserCenterLoginEaseMobSuccessNoti
                                     object:nil];

    }
    return self;
}

- (void)dealloc
{
//    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:nil];
    [GJCFNotificationCenter removeObserver:self];
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
    
    //TODO:WXT
//    [[EMClient sharedClient].chatManager deleteConversation:chatModel.conversation.conversationId deleteMessages:NO];
    
    [self.sourceArray removeObject:chatModel];

    [self.delegate dataManagerRequireRefresh:self requireDeletePaths:@[indexPath]];
}

- (void)loadRecentConversations
{
    RCConnectionStatus state = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    NSLog(@"state = %@", @(state));
    
    BOOL isLogin = [[HTLoginManager getInstance] isLogin];
    if (YES)
    {
        NSArray *types = @[@(ConversationType_PRIVATE),
                           @(ConversationType_DISCUSSION),
                           @(ConversationType_APPSERVICE),
                           @(ConversationType_PUBLICSERVICE),
                           @(ConversationType_GROUP),
                           @(ConversationType_SYSTEM)];
        
        NSArray *allConversation = [[RCIMClient sharedRCIMClient] getConversationList:types];
        [self didUpdateConversationList:allConversation];
    }
}


- (GJGCMessageExtendUserModel *)userInfoFromUserInfo:(RCUserInfo *)userInfo
{
    GJGCMessageExtendUserModel *model = [[GJGCMessageExtendUserModel alloc] init];
    model.userName = userInfo.name;
    model.headThumb = userInfo.portraitUri;
    return model;
}


- (NSString *)displayContentFromMessageBody:(RCMessageContent *)theMessage
{
    NSString *result = nil;
    NSString *identifier = [RCMessageContent getObjectName];
    if ([identifier isEqualToString:@"RC:TxtMsg"])
    {
        RCTextMessage *textMessage = (RCTextMessage *)theMessage;
        result = textMessage.content;
    }
    else if ([identifier isEqualToString:@"RC:VcMsg"])
    {
        result = @"[语音]";
    }
    else if([identifier isEqualToString:@"RC:ImgMsg"])
    {
        result = @"[图片]";
    }
    else
    {
        //Do nothing
    }
    return result;
}

- (void)observeLoginSuccess:(NSNotification *)noti
{
    GJGCRecentChatConnectState state = [[(NSDictionary *)noti.object objectForKey:@"state"]integerValue];
    
    [self.delegate dataManager:self requireUpdateTitleViewState:state];
    
    if (state == GJGCRecentChatConnectStateSuccess) {
        
        [self loadRecentConversations];

    }
}

#pragma mark - 环信监听会话生成的回调

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    if (aConversationList.count > 0) {
        [self updateConversationList:aConversationList];
    }
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    //TODO:WXT
//    [self updateConversationList:[[EMClient sharedClient].chatManager getAllConversations]];
}

#pragma mark - 环信监听链接服务器状态

//- (void)didAutoLoginWithError:(EMError *)aError
//{
//    GJGCRecentChatConnectState resultState = aError? GJGCRecentChatConnectStateFaild:GJGCRecentChatConnectStateSuccess;
//    [self.delegate dataManager:self requireUpdateTitleViewState:resultState];
//}
//
//- (void)didLoginFromOtherDevice
//{
//    
//}

#pragma mark - 监听会话未读数的变化

//- (void)didUnreadMessagesCountChanged
//{
    //TODO:WXT
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    if (self.sourceArray.count == 0 && conversations.count == 0) {
//        return;
//    }
//    
//    [self updateConversationList:conversations];
//}

- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    [self loadRecentConversations];
}



- (void)updateConversationList:(NSArray *)conversationList
{
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (conversationList.count == 0) {
                return;
            }
    
            //重新载入一次会话列表
            if (self.sourceArray.count > 0) {
                [self.sourceArray removeAllObjects];
            }
    
            //按最后一条消息排序
            NSArray *sortConversationList = [conversationList sortedArrayUsingComparator:^NSComparisonResult(RCConversation *obj1, RCConversation *obj2) {
    
                long long timestamp1 = (obj1.sentTime > obj1.receivedTime) ? obj1.sentTime : obj1.receivedTime;
                long long timestamp2 = (obj2.sentTime > obj2.receivedTime) ? obj2.sentTime : obj2.receivedTime;
                
                
                NSComparisonResult result = (timestamp1 > timestamp2) ? NSOrderedAscending : NSOrderedDescending;
                return result;
    
            }];
    
            for (RCConversation *conversation in sortConversationList)
            {
                GJGCRecentChatModel *chatModel = [[GJGCRecentChatModel alloc]init];
                chatModel.conversation = conversation;
                chatModel.toId = conversation.targetId;
                chatModel.unReadCount = conversation.unreadMessageCount;
                
                NSString *title = (conversation.conversationTitle && [conversation.conversationTitle length] > 0) ? conversation.conversationTitle : @"MYTEST";
                chatModel.name = [GJGCRecentChatStyle formateName:title];
                
                if (conversation.conversationType == ConversationType_GROUP)
                {
                    chatModel.isGroupChat = YES;
                    
                    RCMessageContent *lastMessage = conversation.lastestMessage;
                    if (lastMessage)
                    {
                        chatModel.headUrl = lastMessage.senderUserInfo.portraitUri;
                        chatModel.groupInfo = nil;
                    }
                    
                    GJGCMessageExtendUserModel *userInfo = [[GJGCMessageExtendUserModel alloc] init];
                    userInfo.userName = conversation.lastestMessage.senderUserInfo.name;
                    userInfo.headThumb = conversation.lastestMessage.senderUserInfo.portraitUri;
                    NSString *displayContent = [self displayContentFromMessageBody:conversation.lastestMessage];
                    chatModel.content = displayContent;
                    chatModel.time = [GJGCRecentChatStyle formateTime:conversation.sentTime/1000];
                    [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
    
                }
    
                if (conversation.conversationType == ConversationType_PRIVATE) {
    
                    //对方的最近一条消息
                    chatModel.isGroupChat = NO;
                    RCMessageContent *lastMessage = conversation.lastestMessage;
    
                    if (lastMessage)
                    {
    
                        GJGCMessageExtendUserModel *userInfo = [self userInfoFromUserInfo:lastMessage.senderUserInfo];
                        if (userInfo.userName && [userInfo.userName length] > 0)
                        {
                            chatModel.name = [GJGCRecentChatStyle formateName:userInfo.userName];
                           
                        }else{
                            chatModel.name = [GJGCRecentChatStyle formateName:conversation.targetId];
                        }
                        
                        chatModel.headUrl = userInfo.headThumb;
    
                    }else{
    
                        chatModel.name = [GJGCRecentChatStyle formateName:conversation.targetId];
                        chatModel.headUrl = @"";
                    }
                    
                    long long timeStamp = (conversation.sentTime > conversation.receivedTime) ? conversation.sentTime : conversation.receivedTime;
                    chatModel.content = [self displayContentFromMessageBody:conversation.lastestMessage];
                    chatModel.time = [GJGCRecentChatStyle formateTime:timeStamp/1000];
                    [GJGCChatFriendCellStyle formateSimpleTextMessage:chatModel.content];
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


#pragma mark - 监听网络变化，尝试重新登录
- (void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_Connected)
    {
        //DO something
        //如果未连接成功连接
    }
    
    switch (status)
    {
        case ConnectionStatus_Connected:
            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateSuccess];
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

//- (void)didConnectionStateChanged:(EMConnectionState)connectionState
//{
    //TODO:WXT
//    if (connectionState == EMConnectionConnected) {
//        
//        if (![[EMClient sharedClient] isLoggedIn]) {
//            
//            [[ZYUserCenter shareCenter] autoLogin];
//        }
//    }
//    
//    switch (connectionState) {
//        case EMConnectionConnected:
//        {
//            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateSuccess];
//        }
//            break;
//        case EMConnectionDisconnected:
//        {
//            [self.delegate dataManager:self requireUpdateTitleViewState:GJGCRecentChatConnectStateConnecting];
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - 检测会话是否已经存在

+ (BOOL)isConversationHasBeenExist:(NSString *)chatter
{
    //TODO:WXT
    return nil;
//    NSInteger findIndex = NSNotFound;

//    for (EMConversation *conversation in [[EMClient sharedClient].chatManager getAllConversations]) {
//        
//        if ([conversation.conversationId isEqualToString:chatter]) {
//            
//            findIndex = 1;
//            break;
//        }
//    }
//    
//    return findIndex == NSNotFound? NO:YES;
}

@end
