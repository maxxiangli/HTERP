//
//  GJGCRecentChatViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatViewController.h"
#import "GJGCRecentChatCell.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCChatGroupViewController.h"
#import "GJGCRecentChatDataManager.h"
#import "GJGCRecentChatTitleView.h"
#import "GJGCChatSystemNotiReciever.h"
#import "GJGCChatSystemNotiViewController.h"
#import "AppDelegate.h"

#import "CHRCIMDataSource.h"

#import <RongIMLib/RongIMLib.h>

@interface GJGCRecentChatViewController ()<UITableViewDelegate,UITableViewDataSource,GJGCRecentChatDataManagerDelegate>

@property (nonatomic,strong)GJGCRecentChatDataManager *dataManager;

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)GJGCRecentChatTitleView *titleView;

@end

@implementation GJGCRecentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [[GJGCRecentChatDataManager alloc]init];
    self.dataManager.delegate = self;
    
    self.titleView = [[GJGCRecentChatTitleView alloc]init];
    self.navigationItem.titleView = self.titleView;
    
    RCConnectionStatus states = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    GJGCRecentChatConnectState result = [self chatConnectStateFromRCStatus:states];
    self.titleView.connectState = result;
    
    self.listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth, GJCFSystemScreenHeight - self.tabBarController.tabBar.gjcf_height - self.contentOriginY) style:UITableViewStylePlain];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTable];
    
    [self.dataManager performSelector:@selector(loadRecentConversations)
                           withObject:nil
                           afterDelay:2.0];
    
    //TODO:测试使用
    {
        [self setRightButtonWithStateImage:@"title-icon-个人资料" stateHighlightedImage:nil stateDisabledImage:nil titleName:nil];
    }
}

//TODO:测试使用
- (void)rightButtonPressed:(UIButton *)sender
{
//    NSArray *users = @[@"1479369785100021571",@"1478743481879054151",@"1478933128765095651"];
//    [[CHRCIMDataSource sharedRCIMDataSource] createChatRoom:@"聊天室" users:users];
    
//    1479817853683015991
    
    
//    NSArray *quitUsers = @[@"1478933128765095651,1479369785100021571"];
//    [[CHRCIMDataSource sharedRCIMDataSource] quitChatRoom:@"1479817853683015991" quitUsers:quitUsers];
    
    
//    [[CHRCIMDataSource sharedRCIMDataSource] joinChatRoom:@"1479817853683015991" joinUsers:quitUsers];
    
    [[CHRCIMDataSource sharedRCIMDataSource] getRoomUsers:@"1479817853683015991"];
}


- (NSArray *)allConversationModels
{
    return [self.dataManager allConversationModels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重新刷新一下会话
    [self.dataManager loadRecentConversations];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    GJGCRecentChatCell *recentCell = (GJGCRecentChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!recentCell) {
        
        recentCell = [[GJGCRecentChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [recentCell setContentModel:[self.dataManager contentModelAtIndexPath:indexPath]];
    
    return recentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataManager contentHeightAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJGCRecentChatModel *contenModel = [self.dataManager contentModelAtIndexPath:indexPath];
    
    if (contenModel.isGroupChat) {
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc] init];
        talk.talkType = GJGCChatFriendTalkTypeGroup;
        talk.toId = contenModel.toId;
        talk.toUserName = contenModel.name.string;
        talk.converstation = contenModel.conversation;
        talk.groupInfo = contenModel.groupInfo;
        
        GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
        
        [self.navigationController pushViewController:groupChat animated:YES];
        
        return;
    }
    
    //助手消息
    if ([contenModel.toId isEqualToString:SystemAssistConversationId]) {
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkSystemAssist;
        talk.toId = contenModel.toId;
        talk.toUserName = contenModel.name.string;
        talk.converstation = contenModel.conversation;
        
        GJGCChatSystemNotiViewController *systemVC = [[GJGCChatSystemNotiViewController alloc]initWithTalkInfo:talk];
        [self.navigationController pushViewController:systemVC animated:YES];
        return;
    }
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = contenModel.toId;
    talk.toUserName = contenModel.name.string;
    talk.converstation = contenModel.conversation;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    [self.navigationController pushViewController:privateChat animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            [self.dataManager deleteConversationAtIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - dispatch缓冲刷新会话列表

- (void)conversationListUpdate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.view.window != nil) {
            [self.listTable reloadData];
        }
        
    });
}

#pragma mark - RecentDataManager

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager
{
    [self conversationListUpdate];
}

- (void)dataManagerRequireRefresh:(GJGCRecentChatDataManager *)dataManager requireDeletePaths:(NSArray *)paths
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.listTable deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
        
    });
}

- (void)dataManager:(GJGCRecentChatDataManager *)dataManager requireUpdateTitleViewState:(GJGCRecentChatConnectState)connectState
{
    self.titleView.connectState = connectState;
}

#pragma mark - Private function

- (GJGCRecentChatConnectState)chatConnectStateFromRCStatus:(RCConnectionStatus)status
{
    GJGCRecentChatConnectState result = GJGCRecentChatConnectStateFaild;
    
    if (status == ConnectionStatus_Connected)
    {
        result = GJGCRecentChatConnectStateSuccess;
    }
    else if (status == ConnectionStatus_Connecting)
    {
        result = GJGCRecentChatConnectStateConnecting;
    }
    else if (status == ConnectionStatus_SignUp ||
             status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT ||
             status == ConnectionStatus_TOKEN_INCORRECT)
    {
        result = GJGCRecentChatConnectStateFaild;
    }
    else
    {
        result = GJGCRecentChatConnectStateConnecting;
    }
    
    return result;
}

@end
