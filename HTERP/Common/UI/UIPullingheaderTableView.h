//
//  UIPullingheaderTableView.h
//  QQStock
//
//  Created by xinggang li on 1/16/12.
//  Copyright (c) 2012 tencent. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@protocol UIPullingheaderDelegate;

@interface UIPullingheaderTableView : UITableView <UITableViewDelegate,EGORefreshTableHeaderDelegate> {
@protected
    __weak id<UITableViewDelegate,UIPullingheaderDelegate> _secondDelegate;
@private

    EGORefreshTableHeaderView *_refreshView;
}

@property (nonatomic,copy)   NSString *timeStamp;
@property (nonatomic,assign) BOOL forbidLoading;
@property (nonatomic,assign) BOOL isFullScreen;

-(void)setHeaderTableViewBackgroudColor:(UIColor *)color;
-(void)setTimeStampToDate:(NSDate *)dateValue;
-(void)finishedRefreshLoading:(NSTimeInterval) delay;
-(void)refreshLastUpdatedDate;
-(void)enforceRefreshLoading;
-(void)enforceRefreshLoading:(BOOL)animated;

// 判断是否是拉下的状态
-(BOOL)isUpdatingData;
// 切换皮肤
-(void) changeDisplayTheme;

//add by jinruinie
-(EGORefreshTableHeaderView*)getRefreshView;
@end

@protocol UIPullingheaderDelegate <NSObject>
-(void)onInvokePullingRefresh:(UIPullingheaderTableView *)view;
@end

//Group样式的tableview：headview固定在scrollview上，不飘浮。奇葩的需求
@interface UIPullingheaderGroupTableView : UIPullingheaderTableView <UITableViewDataSource, UITableViewDelegate,UIPullingheaderDelegate> {
    __weak id<UITableViewDataSource> _myDataSrouce;
    __weak id<UITableViewDelegate,UIPullingheaderDelegate> _myDelegate;
}
@end
