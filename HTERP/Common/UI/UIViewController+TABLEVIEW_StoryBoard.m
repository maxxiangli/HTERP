//
// UIViewController+TABLEVIEW_StoryBoard.m
// qqstock
//
// Created by zheliang on 周六 2014-04-26.
// Copyright (c) 2014年 zheliang. All rights reserved.
//

#import "UIViewController+TABLEVIEW_StoryBoard.h"
#import "UIStoryBoardTableView.h"
#import "CNoDataView.h"

#define str_fmt(fmt, ...)                   [NSString stringWithFormat : fmt,##__VA_ARGS__]

NSString   *kDesignableTableViewDefaultTableViewCellIdenifier = @"content";
NSString   *kDesignableTableViewDefaultNumberOfRow            = @"10";

@interface UITableViewRowModel ()
@end
@implementation UITableViewRowModel
+ (UITableViewRowModel*)modelWithIdentifier:(NSString*)identifier data:(id)data delegate:(NSObject<UITableViewCell_StoryBoardDelegate>*) delegate
{
    UITableViewRowModel   *model = [[UITableViewRowModel alloc] init] ;
    model.delegate = delegate;
    model.identifier = identifier;
    model.data       = data;
    model.height = -1;
    return model;
}

- (void)dealloc
{
	self.data = nil;
	self.identifier = nil;
	
}
@end

@implementation UITableViewSectionModel

- (void)dealloc
{
	self.title = nil;
	[self.rows removeAllObjects];
	self.rows = nil;
	

}
@end


@interface UITableViewModel ()
@property (nonatomic, strong)     NSMutableArray   *sections;

@end
@implementation UITableViewModel
{
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _sections = [NSMutableArray array];
    }

    return self;
}

- (void)dealloc
{
	[_sections removeAllObjects];
	
	
}

- (NSString*)keyForSection:(NSInteger)sectionIndex
{
    return str_fmt(@"section-%ld", (long)sectionIndex);
}

- (UITableViewSectionModel*)modelForSection:(NSInteger)section
{
    UITableViewSectionModel   *model = [_sections objectAtIndex_s:section];

    if (!model)
    {
        model      = [[UITableViewSectionModel alloc] init];
        model.rows = [NSMutableArray array];
        [_sections addObject_s:model];
//        [_sections setValue:model forKey:[self keyForSection:section]];
		
    }

    return model;
} /* sectionModel */

- (void)InsertSection:(NSInteger)section
{
    UITableViewSectionModel* model      = [[UITableViewSectionModel alloc] init];
    model.rows = [NSMutableArray array];
    [_sections insertObject_s:model atIndex:section];
}

- (void)setTitle:(NSString*)title forSection:(NSInteger)section
{
    UITableViewSectionModel   *model = [self modelForSection:section];

    model.title = title;
} /* setTitle */

- (NSString*)titleForSection:(NSInteger)section
{
    return [[self modelForSection:section] title];
}

- (NSInteger)numberOfSections
{
    return [_sections count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[[self modelForSection:section] rows] count];
}

- (UITableViewSectionModel*)modelForSectionAtIndex:(int)section
{
    return [self modelForSection:section];
}

- (void)addRow:(UITableViewRowModel*)row forSection:(NSInteger)section
{
    [[[self modelForSection:section] rows] push:row];
}

- (void)insertRow:(UITableViewRowModel*)row forIndexPath:(NSIndexPath*)indexPath
{
    [[[self modelForSection:indexPath.section] rows] insertObject:row atIndex:indexPath.row];
}

- (void)removeSection:(NSInteger)section
{
    [_sections removeObjectAtIndex_s:section];
}

- (void)removeSections:(NSIndexSet *)sections
{
    [_sections removeObjectsAtIndexes:sections];
}

- (UITableViewRowModel*)modelForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[[self modelForSection:indexPath.section] rows] at:indexPath.row];
}

- (NSString*)identifierForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self modelForRowAtIndexPath:indexPath] identifier];
}

- (id)dataForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self modelForRowAtIndexPath:indexPath] data];
}

-(id)dataForLastRowAtSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self numberOfRowsInSection:section] - 1) inSection:section];
    return [[self modelForRowAtIndexPath:indexPath] data];
}

- (void)removeRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[[self modelForSection:indexPath.section] rows] removeObjectAtIndex:indexPath.row];
}


- (void)clear
{
    [_sections removeAllObjects];
}
@end

@interface UIViewController_TABLEVIEW_StoryBoard ()
@property (strong, nonatomic) UIImage* noDataImage;
@property (strong, nonatomic) NSString* noDataText;

@end

@implementation UIViewController_TABLEVIEW_StoryBoard
{
    UITableViewModel      *_dataModel;
    NSMutableDictionary   *_cellsForHeightCalculate;

}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.staticCellHeight = NO;
    }

    return self;
}



- (void)dealloc
{
	self.tableView = nil;
	[_cellsForHeightCalculate removeAllObjects];
	

	
	
}

-(void)setupInterface {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.staticCellHeight = NO;//默认计算所有cell高度 为YES时相同id的cell只计算一次

	_dataModel                = [[UITableViewModel alloc] init];
	if ([self useIOS7NewFeatures]) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 44.0; 
	}
    [self buildDesignUI];
}

- (BOOL)useIOS7NewFeatures
{
    if (isiOS8Later) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)buildDesignUI
{
    _cellsForHeightCalculate = [NSMutableDictionary dictionary];

   } /* buildDesignUI */

#pragma mark -
- (UITableViewModel*)tableViewModel
{
    return _dataModel;
}

- (void)updateModel:(UITableViewModel*)dataModel
{
    if (dataModel == nil) {
        [self clearData];
        return;
    }



    if (_dataModel != dataModel)
    {

        _dataModel                = dataModel ;

        self.tableView.dataSource = self;
        self.tableView.delegate   = self;
//如果用系统动画滚动 或者 设置与reload并发 在低端手机 会出现滚动异常
        [UIView animateWithDuration:.2 animations:^{
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];

        } completion:^(BOOL finished) {
            [self.tableView reloadData];

        }];
    }
    else
    {
        [self.tableView reloadData];
    }
    if (self.noDataImage || self.noDataText) {
        if ([self hasData]) {
            [self hideNoDataView:YES];
        }
        else
        {
            [self hideNoDataView:NO];
            
        }
    }
} /* updateModel */

- (void)updateModelNoScollToTop:(UITableViewModel*)dataModel;
{
    if (dataModel == nil) {
        [self clearData];
        return;
    }


    if (_dataModel != dataModel)
    {

        _dataModel                = dataModel ;
        
        self.tableView.dataSource = self;
        self.tableView.delegate   = self;
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView reloadData];
    }
    if (self.noDataImage || self.noDataText) {
        if ([self hasData]) {
            [self hideNoDataView:YES];
        }
        else
        {
            [self hideNoDataView:NO];
            
        }
    }
} /* updateModel */

- (void)setNoDataTips:(UIImage *)image text:(NSString *)text
{
    self.noDataImage = image;
    self.noDataText = text;
}
- (void)hideNoDataView:(BOOL)hidden
{
    if (hidden) {
        [CNoDataView hideForView:self.tableView];
    }
    else
    {
        [CNoDataView hideForView:self.tableView];
        [CNoDataView addedTo:self.tableView image:self.noDataImage text:self.noDataText];

    }
}

- (void)showNetWorkErrorTipsView:(UIImage *)image text:(NSString *)text
{
    [CNoDataView hideForView:self.tableView];
    [CNoDataView addedTo:self.tableView image:image text:text];

}
- (BOOL)hasData
{
    for ( UITableViewSectionModel* section in _dataModel.sections) {
        if (section.rows.count > 0) {
            return YES;
        }
    }
    return NO;
}

/**
 *  为 Cell 填充数据，子类不能调用
 *
 *  @param cell      要填充的 Cell
 *  @param data      要给 Cell 的 data 数据, Cell 要在自己的 setData 方法中将 id 类型的数据转为自己需要的类型
 *  @param indexPath Cell 的 indexPath
 */
- (void)configureCell:(UITableViewCell*)cell data:(id)data indexPath:(NSIndexPath*)indexPath
{
	if ([cell isKindOfClass:[UITableViewCell_StoryBoard class]]) {
        ((UITableViewCell_StoryBoard*)cell).cellData = data;
        ((UITableViewCell_StoryBoard*)cell).delegate = self;
        ((UITableViewCell_StoryBoard*)cell).tableView = self.tableView;

		[((UITableViewCell_StoryBoard*)cell) setData:data];
	}
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [_dataModel numberOfSections];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataModel numberOfRowsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewRowModel   *rowModel   = [_dataModel modelForRowAtIndexPath:indexPath];
    NSString              *identifier = [rowModel identifier];
    UITableViewCell       *cell       = [self.tableView dequeueReusableCellWithIdentifier:identifier];

//    if (!cell)
//    {
//        Error(@"cell for %@ is nil", identifier);
//    }
    if ([cell isKindOfClass:[UITableViewCell_StoryBoard class]]) {
        ((UITableViewCell_StoryBoard*)cell).delegate = rowModel.delegate;

    }
    [self configureCell:cell data:[rowModel data] indexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
} /* tableView */

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataModel titleForSection:section];
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if ([self useIOS7NewFeatures]) {
		return UITableViewAutomaticDimension;

	}
    UITableViewRowModel   *rowModel   = [_dataModel modelForRowAtIndexPath:indexPath];
    //如果高度已经计算并缓存 直接返回
    if (rowModel.height != -1 && rowModel) {
        return rowModel.height;
    }
    NSString              *identifier = [rowModel identifier];
    UITableViewCell       *cell       = [_cellsForHeightCalculate valueForKey:identifier];

    if (!cell)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

        [_cellsForHeightCalculate setObject:cell forKey:identifier];
    }
    ////相同identifier cell高度相同 只计算一次
    else if(self.staticCellHeight)
    {
        //如果有相同identifier的cell 计算过高度 那么直接返回
        UITableViewRowModel   *model   = [self.tableViewModel modelForRowAtIndexPath:((UITableViewCell_StoryBoard*)cell).indexPath];
        
        if (model.height != -1 && [model.identifier isEqualToString:identifier]) {
            return model.height;
        }
    }
    if (!cell)
    {

        return 0;
    }

    [cell prepareForReuse];

    [self configureCell:cell data:[rowModel data] indexPath:indexPath];
    
    
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:cell.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:CGRectGetWidth(self.tableView.frame)];
    [cell.contentView addConstraint:tempWidthConstraint];
    
//    //让cell进行layout
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];

    // Auto layout engine does its math
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [cell.contentView removeConstraint:tempWidthConstraint];
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    CGFloat height = fittingSize.height;

    if (height == 0)
    {
        height = cell.frame.size.height;
    }
    /**
     *  将计算好的高度缓存到cache中 第二次将不再计算
     */
    if (rowModel.height == -1) {
        rowModel.height = height;
    }

    return height;
} /* tableView */


/**
 *  子类重写此方法处理 Cell 的点击事件
 *
 *  @param indexPath 被点击 Cell 的 indexPath
 *  @param data      被点击 Cell 的 model 数据
 */
- (void)didSelect:(NSIndexPath *)indexPath data:(id)data
{

}

- (void)didDeSelect:(NSIndexPath *)indexPath data:(id)data
{
    
}

- (void)clearData
{
    if (self.noDataImage || self.noDataText) {
        [self hideNoDataView:NO];
    }
    if ([self hasData]) {
        [[self tableViewModel] clear];
        [self.tableView reloadData];
    }
}
- (void)clearDataNoUpdate
{
    if (self.noDataImage || self.noDataText) {
        [self hideNoDataView:NO];
    }
    if ([self hasData]) {
        [[self tableViewModel] clear];
    }
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewRowModel   *rowModel   = [_dataModel modelForRowAtIndexPath:indexPath];
	[self didSelect:indexPath data:rowModel.data];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowModel   *rowModel   = [_dataModel modelForRowAtIndexPath:indexPath];
    [self didDeSelect:indexPath data:rowModel.data];
}
- (void)    tableView:(UITableView*)tableView
      willDisplayCell:(UITableViewCell*)cell
    forRowAtIndexPath:(NSIndexPath*)indexPath
{
 #if 0
        cell.transform = CGAffineTransformMakeTranslation(10, 0);
        [UIView animateWithDuration:.3 animations: ^{
        cell.transform = CGAffineTransformMakeTranslation(-10, 0);
    } completion: ^(BOOL finished) {
        // cell.transform = CGAffineTransformMakeScale(1.0,1.0);
    }];
 #endif
}

- (void)insertRowAtIndexPath:(UITableViewRowModel*)row indexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    if (_dataModel == nil) {
        _dataModel = [UITableViewModel new];
    }
    if (row) {
        [self hideNoDataView:YES];

    }
    if (![self hasData]) {
        [self.tableViewModel addRow:row forSection:indexPath.section];
        [self.tableView reloadData];
        return;
    }
    [self.tableViewModel insertRow:row forIndexPath:indexPath];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)insertRowsAtIndexPaths:(NSArray<UITableViewRowModel *>*)rows indexPaths:(NSArray<NSIndexPath*> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (rows.count == 0 || indexPaths.count == 0) {
        return;
    }
    
    //依次取出数组中model 插入 ,最后统一插入indexpath，避免批量插入crash
    if (_dataModel == nil) {
        _dataModel = [UITableViewModel new];
    }
    if (rows.count > 0) {
        [self hideNoDataView:YES];
    }
    if ([self hasData] == NO && rows.count > 0) {
        for (int i = 0; i < rows.count; i++) {
            UITableViewRowModel * rowModel = [rows objectAtIndex_s:i];
            if (rowModel) {
                NSIndexPath* indexPath = [indexPaths objectAtIndex_s:i];
                if (indexPath) {
                    [self.tableViewModel addRow:rowModel forSection:indexPath.section];
                }
            }
        }
        [self.tableView reloadData];
        return;
    }
    for (int i = 0; i < rows.count; i++) {
        UITableViewRowModel * rowModel = [rows objectAtIndex_s:i];
        if (rowModel) {
            NSIndexPath* indexPath = [indexPaths objectAtIndex_s:i];
            if (indexPath) {
                [self.tableViewModel insertRow:rowModel forIndexPath:indexPath];

            }
        }
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];

}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewModel removeRowAtIndexPath:indexPath];
   [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPath:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
        if (!mutableIndexSet) {
            mutableIndexSet = [NSMutableIndexSet indexSet];
            mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
        }
        [mutableIndexSet addIndex:indexPath.row];
    }];
    
    [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            [[self.tableViewModel modelForSection:key.integerValue].rows removeObjectsAtIndexes:indexSet];
    }];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];

}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewModel InsertSection:sections.firstIndex ];
    [self.tableView insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewModel removeSections:sections];
    [self.tableView deleteSections:sections withRowAnimation:animation];
}
@end

