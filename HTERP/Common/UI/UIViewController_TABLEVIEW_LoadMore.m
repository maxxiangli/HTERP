//
//  UIViewController_TABLEVIEW_LoadMore.m
//  QQStock
//
//  Created by zheliang on 15/4/1.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "UIViewController_TABLEVIEW_LoadMore.h"
#define DEFAULT_HEIGHT_OFFSET 52.0f

@interface UIViewController_TABLEVIEW_LoadMore ()
{
}
@property (nonatomic, assign) BOOL visable;
@end

@implementation UIViewController_TABLEVIEW_LoadMore

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_loadMoreFooterView == nil) {
        CLoadMoreTableFooterView *view = [[CLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        view.autoresizingMask = UIViewAutoresizingNone;
        self.loadMoreFooterView = view;
        self.visable = NO;
        
        
    }	
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [self.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)setFooterViewVisibility:(BOOL)visible
{
    self.visable = visible;
    if (visible &&  self.loadMoreFooterView.superview == nil)
        [self.tableView addSubview:self.loadMoreFooterView];

    else if (!visible && self.loadMoreFooterView.superview)
        [self.loadMoreFooterView removeFromSuperview];

}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.visable) {
        [self.loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];

    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.visable) {

    [self.loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(CLoadMoreTableFooterView *)view {
    
    [self reloadTableViewDataSource];
//     [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(CLoadMoreTableFooterView *)view {
    return _reloading;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.loadMoreFooterView=nil;
}

- (void)dealloc {
    
    self.loadMoreFooterView = nil;
    
}

- (void)setActivityColor:(UIColor *)color
{
    if (self.loadMoreFooterView) {
        [self.loadMoreFooterView setActivityColor:color];
    }
}

@end
