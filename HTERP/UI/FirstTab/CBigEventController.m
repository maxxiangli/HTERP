//
//  CBigEventController.m
//  QQStock
//
//  Created by li xiang on 16/6/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CBigEventController.h"
#import "CBigEventReminderParam.h"
#import "CLoginStateJSONRequestCommand.h"
#import "UIStoryBoardPullingheaderTableView.h"
#import "CATradeLoadingView.h"
#import "CBigEventReminderModel.h"
#import "CBigEventCell.h"
//#import "CNewsContentViewController.h"
//#import "CStockDetailController.h"
#import "CBigEventNoMoreDataTableViewCell.h"
//#import "CDragonTigerDetailViewController.h"
#import "HTLoginLoginViewController.h"

@interface CBigEventController ()
@property(nonatomic, strong) UIButton *failedButton;
@property(nonatomic, assign) NSInteger nextPageIndex;
@property(nonatomic, assign) NSInteger totoalPage;
@end

@implementation CBigEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_DefaultBackgroundColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBigEventNoMoreDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"CBigEventNoMoreDataTableViewCell"];
    // Do any additional setup after loading the view.
    if ( [self.stockName isKindOfClass:[NSString class]] )
    {
        [self setDisplayCustomTitleText:[NSString stringWithFormat:@"%@-大事提醒详情", self.stockName]];
    }
    else
    {
        [self setDisplayCustomTitleText:@"大事提醒详情"];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    
    self.failedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.failedButton.frame = self.view.bounds;
    [self.view addSubview:self.failedButton];
    self.failedButton.titleEdgeInsets = UIEdgeInsetsMake(-44, 0, 0, 0);
    [self.failedButton setTitle:@"数据加载失败，点击重试" forState:UIControlStateNormal];
    [self.failedButton setTitleColor:TC_DefaultStockCodeColor forState:UIControlStateNormal];
    [self.failedButton addTarget:self action:@selector(requestFirstPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self showLoadDataFail:NO];
    
    [self initRightView];
    
    self.nextPageIndex = 1;

    [self requestData];
}

- (void)initRightView
{
    CCustomButton *hangQingButton = [CCustomButton buttonWithTitle:@"行情" style:eCustomButtonStyleSquare];
    [hangQingButton setFrame:CGRectMake(0, 0, 40, 44)];
    [hangQingButton addTarget:self action:@selector(onHangQingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hangqingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hangQingButton];
    self.navigationItem.rightBarButtonItem = hangqingButtonItem;
}

//显示加载失败
- (void)showLoadDataFail:(BOOL)show
{
    self.failedButton.hidden = !show;
}

- (void)onHangQingBtnClick:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HTLogin" bundle:nil];
    HTLoginLoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (BOOL)isFirstPage
{
    if ( self.nextPageIndex <= 2 )
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isLastPage {
    if (self.nextPageIndex > self.totoalPage) {
        return YES;
    }
    
    return NO;
}

- (void)requestData
{
    CBigEventReminderParam *params = [[CBigEventReminderParam alloc] init];
    params.symbol = self.stockCode;
    params.page = self.nextPageIndex;

    [CATradeLoadingView showLoadingViewAddedTo:self.view];
    __weak typeof(self) weakSelf = self;
    [CLoginStateJSONRequestCommand getWithParams:params modelClass:[CBigEventReminderModel class] sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        //关闭loading
        
        if ([weakSelf.tableView isKindOfClass:[UIStoryBoardPullingheaderTableView class]])
        {
            [((UIStoryBoardPullingheaderTableView*)weakSelf.tableView) setTimeStampToDate:[NSDate date]];
            [((UIStoryBoardPullingheaderTableView*)weakSelf.tableView) finishedRefreshLoading:0.0];
        }
        
        [weakSelf doneLoadingTableViewData];
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        //更新ui
        if ( !requestCommand.responseModel )
        {
            return;
        }
        
        CBigEventReminderModel *model = (CBigEventReminderModel*)requestCommand.responseModel;
        if ( ![model isKindOfClass:[CBigEventReminderModel class]] )
        {
            return;
        }
        
        //
        if ( [model.list count] )
        {
            self.nextPageIndex++;
        }
        
        //是否还有数据
        self.totoalPage = model.totalPage;
        
        if ([self isLastPage]) {
            [weakSelf setFooterViewVisibility:NO];
        }else {
            [weakSelf setFooterViewVisibility:YES];
        }

        UITableViewModel *tableModel = [weakSelf tableViewModel];
        
        if ( [self isFirstPage] )
        {
            [tableModel clear];
        }
        
        if ( !tableModel )
        {
            tableModel = [UITableViewModel new] ;
        }
        
        for ( CBigEventReminderItemModel *item in model.list )
        {
            [tableModel addRow:TABLEVIEW_ROW(@"bigEventCell", item) forSection:0];
        }
        
        if ([self isLastPage]) {
            [tableModel addRow:TABLEVIEW_ROW(@"CBigEventNoMoreDataTableViewCell", @"无更多数据") forSection:0];
        }

        [weakSelf updateModel:tableModel];
        
        if ( [self isHaveData] )
        {
            [self showLoadDataFail:NO];
        }
        else
        {
            [self showLoadDataFail:YES];
        }
        
    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        //关闭loading
        [weakSelf doneLoadingTableViewData];
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        if ( [self isHaveData] )
        {
            [self showLoadDataFail:NO];
        }
        else
        {
            [self showLoadDataFail:YES];
        }
    }];
    
}

- (BOOL)canShowDateImg:(NSIndexPath *)indexPath
{
    //当前cell和上一个cell的日期相同，则不显示dateimg
    if ( 0 == indexPath.row )
    {
        return YES;
    }
    
    CBigEventReminderItemModel *curItem = (CBigEventReminderItemModel *)[self.tableViewModel modelForRowAtIndexPath:indexPath].data;
    CBigEventReminderItemModel *perItem = (CBigEventReminderItemModel *)[self.tableViewModel modelForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]].data;
    
    if ( [curItem isKindOfClass:[CBigEventReminderItemModel class]] && [perItem isKindOfClass:[CBigEventReminderItemModel class]] )
    {
        if ( ![curItem.year isEqualToString:perItem.year] )
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)requestFirstPage
{
    self.nextPageIndex = 1;
    [self requestData];
}

- (BOOL)isHaveData
{
    UITableViewModel *tableModel = [self tableViewModel];
    if ( [tableModel isKindOfClass:[UITableViewModel class]] && [tableModel numberOfRowsInSection:0] )
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - 下拉and上提刷新
-(void)onInvokePullingRefresh:(UIStoryBoardPullingheaderTableView *)view
{
    [self requestFirstPage];
}

- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    [self requestData];
}

#pragma  mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CBigEventCell *cell = (CBigEventCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ( ![cell isKindOfClass:[CBigEventCell class]] )
    {
        return cell;
    }
    
    if ( [self canShowDateImg:indexPath] )
    {
        [cell hideDateImg:NO];
    }
    else
    {
        [cell hideDateImg:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBigEventReminderItemModel *curItem = (CBigEventReminderItemModel *)[self.tableViewModel modelForRowAtIndexPath:indexPath].data;
    if ( ![curItem isKindOfClass:[CBigEventReminderItemModel class]] )
    {
        return;
    }
    
    if ( [curItem.noticeId isKindOfClass:[NSString class]] && [curItem.noticeId length] )
    {
//        CNewsContentViewController *controller=[[CNewsContentViewController alloc] init];
//        CNewsInfo *newsInfo = [[CNewsInfo alloc] init];
//        newsInfo.newsListID = kNewsListIDSingleStockNotice;
//        newsInfo.newsID = curItem.noticeId;
//        newsInfo.newsTitle = curItem.title;
//        newsInfo.stockID = self.stockCode;
//        newsInfo.stockName = self.stockName;
//        
//        [controller setNewsContentByInfo:newsInfo withStockName:self.stockName];
//        [CBossReporter reportUserEvent:@"sd_dstx_click_content" stockCode:newsInfo.stockID];
//        [self.navigationController pushViewController:controller animated:YES];
//        
        return;
    }
    
    if ( [curItem.typeStr isKindOfClass:[NSString class]] && [curItem.typeStr isEqualToString:@"龙虎榜"]
        && [curItem.date isKindOfClass:[NSString class]] && [curItem.date length]
        )
    {
//        NSString *dateStr = [curItem.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        [CDragonTigerDetailViewController gotoDragonTigerDetailViewIn:self.navigationController stockName:self.stockName stockCode:self.stockCode date:dateStr];
    }
}
@end
