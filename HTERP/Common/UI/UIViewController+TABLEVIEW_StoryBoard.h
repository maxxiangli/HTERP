//
// UIViewController+TABLEVIEW_StoryBoard.h
// qqstock
//
// Created by zheliang on 周六 2014-04-26.
// Copyright (c) 2014年 zheliang. All rights reserved.
//

#import "CCustomViewController.h"
#define _TYPE(_type, ...)
#import "UITableViewCell_StoryBoard.h"
#import "CCustomBackButtonController.h"

@interface UITableViewRowModel : NSObject
@property ( nonatomic, strong ) NSString   *identifier;
@property ( nonatomic, strong ) id          data;
@property ( nonatomic, weak ) NSObject<UITableViewCell_StoryBoardDelegate>* delegate;
@property (nonatomic, assign) CGFloat height;//没有计算过时候默认-1;

+ (UITableViewRowModel*)modelWithIdentifier:(NSString*)identifier data:(id)data delegate:(NSObject<UITableViewCell_StoryBoardDelegate>*) delegate;
@end

#define TABLEVIEW_ROW(identifier_, data_) [UITableViewRowModel modelWithIdentifier : identifier_ data : data_ delegate:nil]
#define TABLEVIEW_ROW_With_Delegate(identifier_, data_, delegate_) [UITableViewRowModel modelWithIdentifier : identifier_ data : data_ delegate:delegate_]

@interface UITableViewSectionModel : NSObject
@property ( nonatomic, strong ) NSString   *title;
@property ( nonatomic, strong )_TYPE(UITableViewRowModel) NSMutableArray * rows;
@end

@interface UITableViewModel : NSObject


- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (UITableViewSectionModel*)modelForSection:(NSInteger)section;
- (void)setTitle:(NSString*)title forSection:(NSInteger)section;
- (NSString*)titleForSection:(NSInteger)section;
- (void)InsertSection:(NSInteger)section;

- (void)addRow:(UITableViewRowModel*)row forSection:(NSInteger)section;
- (void)insertRow:(UITableViewRowModel*)row forIndexPath:(NSIndexPath*)indexPath;

- (void)removeSection:(NSInteger)section;
- (void)removeSections:(NSIndexSet*)sections;

- (UITableViewRowModel*)modelForRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)identifierForRowAtIndexPath:(NSIndexPath*)indexPath;
- (id)dataForRowAtIndexPath:(NSIndexPath*)indexPath;

//add by jinruinie
- (id)dataForLastRowAtSection:(NSInteger)section;

- (void)removeRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)clear;
@end


@interface UIViewController_TABLEVIEW_StoryBoard : CCustomBackButtonController <UITableViewDataSource, UITableViewDelegate,UITableViewCell_StoryBoardDelegate>


@property (nonatomic, weak) IBOutlet UITableView   *tableView;
@property (nonatomic, readonly) UITableViewModel   *tableViewModel;
@property (nonatomic, assign)  BOOL   staticCellHeight; //相同identifier cell高度相同 只计算一次 默认为NO 计算所有cell
/**
 *  构建在interface builder中设计的测试界面
 *  @note 子类需要实现该方法,取消构建测试界面
 *  @since 1.0
 */
- (void)buildDesignUI;

/**
 *  是否使用IOS8tableview自动运算CELL高度特性
 *
 *  @return YES,使用 NO，不使用，使用原始算法
 */
- (BOOL)useIOS7NewFeatures;

/**
 * 使用data配置tableviewcell
 *
 */
- (void)configureCell:(UITableViewCell*)cell data:(id)data indexPath:(NSIndexPath*)indexPath;

/**
 *  更新数据模型
 *
 *  @since 1.0
 */
- (UITableViewModel*)tableViewModel;
- (void)updateModel:(UITableViewModel*)dataModel;
- (void)updateModelNoScollToTop:(UITableViewModel*)dataModel;

- (void)didSelect:(NSIndexPath*)indexPath data:(id)data;
- (void)didDeSelect:(NSIndexPath*)indexPath data:(id)data;
- (void)clearData;
- (void)clearDataNoUpdate;

/**
 *  此方法注意不能连续插入多个cell
 *
 *  @param row          数据
 *  @param indexPath    索引
 *  @param animation    动画
 */
- (void)insertRowAtIndexPath:(UITableViewRowModel*)row indexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
/**
 *   插入多个cell及数据
 *
 *  @param rows      数据数组
 *  @param indexPath 所以数组 务必正序
 *  @param animation 动画
 */
- (void)insertRowsAtIndexPaths:(NSArray<UITableViewRowModel *>*)rows indexPaths:(NSArray<NSIndexPath*> *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
/**
 *  删除多个cell及数据
 *
 *  @param indexPaths 索引数组，务必正序排列
 *  @param animation  动画
 */
- (void)deleteRowsAtIndexPath:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
/**
 *  插入section
 *
 *  @param sections
 *  @param animation 
 */
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  移除section
 *
 *  @param sections
 *  @param animation
 */
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;


/**
 *  设置没有数据时界面显示的图标及文字 当有一个不为空时 无数据时显示
 *  如果用此类的接口设置数据，刷新数据，底层会判断是否显示或隐藏无数据view
 *
 *  @param image 可为空
 *  @param text  可为空
 */
- (void)setNoDataTips:(UIImage*)image text:(NSString*)text;

/**
 *  隐藏无数据view或网络错误view
 *
 *  @param hidden yes:隐藏 no:显示
 */
- (void)hideNoDataView:(BOOL)hidden;

/**
 *  tableviewmodel是否有数据
 *
 *  @return YES：有数据 NO:无数据
 */
- (BOOL)hasData;

/**
 *  显示网络错误视图
 *
 *  @param image image 网络错误图标
 *  @param text  网络错误文字 可为空
 */
- (void)showNetWorkErrorTipsView:(UIImage*)image text:(NSString*)text;
@end
