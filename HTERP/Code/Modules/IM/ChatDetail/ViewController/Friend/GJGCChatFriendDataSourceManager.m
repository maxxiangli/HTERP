//
//  GJGCChatFriendDataSourceManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-12.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendDataSourceManager.h"
#import "GJGCMessageExtendModel.h"
#import "ZYUserCenter.h"

static const NSInteger kGetMessageCount = 20;

@interface GJGCChatFriendDataSourceManager ()
{
    
}

@end

@implementation GJGCChatFriendDataSourceManager

- (void)dealloc
{
    
}

- (instancetype)initWithTalk:(GJGCChatFriendTalkModel *)talk withDelegate:(id<GJGCChatDetailDataSourceManagerDelegate>)aDelegate
{
    if (self = [super initWithTalk:talk withDelegate:aDelegate]) {
        self.title = talk.toUserName;
        
        _isMyFriend = YES;
        
    }
    return self;
}

#pragma mark - 观察本地发送消息创建成功和消息状态更新通知
- (GJGCChatFriendContentModel *)addEasyMessage:(RCMessage *)aMessage
{
    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc] init];
    
    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
    chatContentModel.toId = self.taklInfo.toId;
    chatContentModel.toUserName = self.taklInfo.toUserName;
    chatContentModel.isFromSelf = [self isFromSelf:aMessage];
    chatContentModel.sendStatus = [self sendStatusFromMessage:aMessage];
    chatContentModel.sendTime = (NSInteger)(aMessage.sentTime/1000);
    chatContentModel.senderId = aMessage.senderUserId;
    chatContentModel.localMsgId =  [NSString stringWithFormat:@"%ld",aMessage.messageId];
    chatContentModel.faildReason = @"";
    chatContentModel.faildType = 0;
    chatContentModel.talkType = self.taklInfo.talkType;
    chatContentModel.contentHeight = 0.f;
    chatContentModel.contentSize = CGSizeZero;
    
    GJGCChatFriendContentType contentType = [self formateChatFriendContent:chatContentModel withMessage:aMessage];
    
    if (contentType != GJGCChatFriendContentTypeNotFound) {
        [self addChatContentModel:chatContentModel];
        
        //置为已读
        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:self.taklInfo.converstation.conversationType targetId:self.taklInfo.converstation.targetId];
        
        [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:aMessage.messageId
                                                 receivedStatus:ReceivedStatus_READ];

    }
    
    return chatContentModel;
}

#pragma mark - 数据库读取最后二十条信息

- (void)readLastMessagesFromDB
{
    //如果会话不存在
    if (!self.taklInfo.converstation)
    {
        self.isFinishFirstHistoryLoad = YES;
        self.isFinishLoadAllHistoryMsg = YES;
        return;
    }
    
    //读取最近的20条消息
    RCConversationType type = self.taklInfo.converstation.conversationType;
    NSString *targetId = self.taklInfo.toId;
    NSArray *tmp = [[RCIMClient sharedRCIMClient] getLatestMessages:type
                                                           targetId:targetId
                                                              count:(int)CHGetMessageHistoryCount];
    
    NSArray *latestMessages = [[tmp reverseObjectEnumerator] allObjects];
    for (RCMessage *message in latestMessages)
    {
        [self addEasyMessage:message];
    }
    
    /* 更新时间区间 */
    [self updateAllMsgTimeShowString];
    
    /* 设置加载完后第一条消息和最后一条消息 */
    [self resetFirstAndLastMsgId];
    
    self.isFinishFirstHistoryLoad = YES;
    self.isFinishLoadAllHistoryMsg = NO;
}

#pragma mark - 加载更多信息
- (void)pushAddMoreMsg:(NSArray *)array
{
    /* 分发到UI层，添加一组消息 */
    for (RCMessage *message in array)
    {
        [self addEasyMessage:message];
    }
    
    /* 重排时间顺序 */
    [self resortAllChatContentBySendTime];
    
    /* 上一次悬停的第一个cell的索引 */    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceManagerRequireFinishRefresh:)]) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.delegate dataSourceManagerRequireFinishRefresh:weakSelf];
        });
    }
}

#pragma mark - 更新数据库中消息得高度

- (void)updateMsgContentHeightWithContentModel:(GJGCChatContentBaseModel *)contentModel
{
//    [[GJGCFriendMsgDBAPI share] updateMsgContentHeight:@(contentModel.contentHeight) contentSize:contentModel.contentSize withToId:self.taklInfo.toId withLocalMsgId:contentModel.localMsgId];
}

- (void)updateAudioFinishRead:(NSString *)localMsgId
{
//    [[GJGCFriendMsgDBAPI share] updateAudioMsgFinishRead:[localMsgId longLongValue] toId:self.taklInfo.toId];
}

#pragma mark - Private function
- (BOOL)isFromSelf:(RCMessage *)message
{
    RCUserInfo *userInfo = [[RCIMClient sharedRCIMClient] currentUserInfo];
    if ([userInfo.userId isEqualToString:message.senderUserId])
    {
        return YES;
    }
    return NO;
}

- (GJGCChatFriendSendMessageStatus)sendStatusFromMessage:(RCMessage *)message
{
    GJGCChatFriendSendMessageStatus status = GJGCChatFriendSendMessageStatusFaild;
    if (message.sentStatus == SentStatus_SENDING)
    {
        status = GJGCChatFriendSendMessageStatusSending;
    }
    else if (message.sentStatus == SentStatus_SENT)
    {
        status = GJGCChatFriendSendMessageStatusSuccess;
    }
    else if (message.sentStatus == SentStatus_FAILED)
    {
        status = GJGCChatFriendSendMessageStatusFaild;
    }
    else
    {
        status = GJGCChatFriendSendMessageStatusSuccess;
    }
    
    return status;
}

#pragma mark - Discard
//- (GJGCChatFriendContentModel *)addEaseMessage:(EMMessage *)aMessage
//{
//    return nil;
/* 格式化消息 */
//TODO:WXT
//    GJGCChatFriendContentModel *chatContentModel = [[GJGCChatFriendContentModel alloc]init];
//    chatContentModel.baseMessageType = GJGCChatBaseMessageTypeChatMessage;
//    chatContentModel.toId = aMessage.to;
//    chatContentModel.toUserName = aMessage.to;
//    chatContentModel.isFromSelf = [aMessage.from isEqualToString:[ZYUserCenter shareCenter].currentLoginUser.mobile]? YES:NO;
//    chatContentModel.sendStatus = [[self easeMessageStateRleations][@(aMessage.status)]integerValue];
//    chatContentModel.sendTime = (NSInteger)(aMessage.timestamp/1000);
//    chatContentModel.senderId = aMessage.from;
//    chatContentModel.localMsgId = aMessage.messageId;
//    chatContentModel.faildReason = @"";
//    chatContentModel.faildType = 0;
//    chatContentModel.talkType = self.taklInfo.talkType;
//    chatContentModel.contentHeight = 0.f;
//    chatContentModel.contentSize = CGSizeZero;
//
//    /* 格式内容字段 */
//    GJGCChatFriendContentType contentType = [self formateChatFriendContent:chatContentModel withMsgModel:aMessage];
//
//    if (contentType != GJGCChatFriendContentTypeNotFound) {
//        [self addChatContentModel:chatContentModel];
//
//        //置为已读
//        [self.taklInfo.conversation markMessageAsReadWithId:aMessage.messageId];
//    }
//
//    return chatContentModel;
//}

@end
