//
//  UIViewController_TABLEVIEW_LoadMore.h
//  QQStock
//
//  Created by zheliang on 15/4/1.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "UIViewController+TABLEVIEW_StoryBoard.h"
#import "CLoadMoreTableFooterView.h"

@interface UIViewController_TABLEVIEW_LoadMore : UIViewController_TABLEVIEW_StoryBoard<CLoadMoreTableFooterDelegate>
{
    
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}

@property (nonatomic, retain)     CLoadMoreTableFooterView *loadMoreFooterView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void) setFooterViewVisibility:(BOOL)visible;
- (void)setActivityColor:(UIColor*)color;

@end
