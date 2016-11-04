//
//  UIPullingheaderTableView.m
//  QQStock
//
//  Created by xinggang li on 1/16/12.
//  Copyright (c) 2012 tencent. All rights reserved.
//

#import "UIPullingheaderTableView.h"

@interface UIPullingheaderTableView() {
	CGFloat theDropHeight;
	CGFloat theContentInset;
}
@end

@implementation UIPullingheaderTableView
@synthesize timeStamp = _timeStamp;
@synthesize forbidLoading;
- (void)setTimeStamp:(NSString *)timeStamp
{
    if(timeStamp) {
        _timeStamp = [[NSString alloc] initWithString:timeStamp];
        [_refreshView refreshLastUpdatedDate];
    }
    else {
        _timeStamp = nil;
    }
}

-(void)setHeaderTableViewBackgroudColor:(UIColor *)color
{
    _refreshView.backgroundColor = color;
}

-(void)setTimeStampToDate:(NSDate *)dateValue
{
    if(nil == dateValue)
    {
        dateValue = [NSDate date];
    }
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"最后更新 MM/dd HH:mm:ss"];
    self.timeStamp = [dateFormat stringFromDate:dateValue];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.forbidLoading = NO;
		self.isFullScreen = NO;
        _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -360, CGRectGetWidth(frame), 360)];
        _refreshView.delegate = self;
		_refreshView.edgeInsert = self.contentInset;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_refreshView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.forbidLoading = NO;
        self.isFullScreen = NO;
        _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -360, ScreenWidth, 360)];
        _refreshView.delegate = self;
        _refreshView.edgeInsert = self.contentInset;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_refreshView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_refreshView setFrame:CGRectMake(0.0f, -360, CGRectGetWidth(self.frame), 360)];

}

- (void) setFrame:(CGRect)frame {
	[super setFrame:frame];
	[_refreshView setFrame:CGRectMake(0.0f, -360, CGRectGetWidth(frame), 360)];
}

-(void)dealloc
{
    self.timeStamp = nil;
    
}

-(EGORefreshTableHeaderView*)getRefreshView
{
	return _refreshView;
}

-(void) changeDisplayTheme
{
    [_refreshView changeDisplayTheme];
}

-(void)setDelegate:(id<UITableViewDelegate,UIPullingheaderDelegate>)delegate
{
    super.delegate = self;
    
    _secondDelegate = delegate;
}

-(BOOL)isUpdatingData

{
    if ([_refreshView getPullingState] == EGOOPullRefreshLoading) 
    {
        return YES;
    }
    
    return NO;
}

-(void)delayFinishedRefreshLoading
{
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#warning 此处会导致在频繁往下拖列表时, 出现下拉不正常的情况. 下版中修复.
-(void)finishedRefreshLoading:(NSTimeInterval) delay;
{
    if ( delay < 0.001f )
    {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:delay
                                       target:self 
                                     selector:@selector(delayFinishedRefreshLoading)
                                     userInfo:nil
                                      repeats:NO];
    }
}

- (void)refreshLastUpdatedDate
{
    [_refreshView refreshLastUpdatedDate];
}

-(void)enforceRefreshLoading
{
    [_refreshView egoEnforceLoading:self];
}

-(void)enforceRefreshLoading:(BOOL)animated
{
    [_refreshView egoEnforceLoading:self animated:animated];

}

//////////////////////////////////////////////
//
//      EGORefreshTableHeaderDelegate 
//
//////////////////////////////////////////////


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [_secondDelegate onInvokePullingRefresh:self];
    
    [CBossReporter reportTickInfo:eRepTypeDropdownRefresh];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.forbidLoading;
}


- (NSString*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    if ( self.timeStamp && [self.timeStamp length] > 0 )
        return self.timeStamp;
    else
        return @"需要修改";
//        return [NSString stringWithFormat:@"最后更新 %@", [[CConfiguration sharedConfiguration] getDateNowString:@"MM/dd HH:mm:ss"]];
}



//////////////////////////////////////////////
//
//      UIScrollViewDelegate 
//
//////////////////////////////////////////////

#pragma mark - protocol UIScrollViewDelegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)] ){
        
        [_secondDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshView.contentInsert == 0 && _isFullScreen) _refreshView.contentInsert = self.contentInset.top;
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
	
    if ((id)self != _secondDelegate && [_secondDelegate respondsToSelector:@selector(scrollViewDidScroll:)] ){
        
        [_secondDelegate scrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)] ){
        
        [_secondDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)] ){
        
        [_secondDelegate scrollViewDidEndDecelerating:scrollView];
    }
}


//////////////////////////////////////////////
//
//      UITableViewDelegate 
//
//////////////////////////////////////////////
#pragma mark - protocol UITableViewDelegate 

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] ){
    
        [_secondDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] )
    {
        return [_secondDelegate tableView:tableView heightForHeaderInSection:section];
    }
    
    return 0.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] )
    {
        return [_secondDelegate tableView:tableView heightForFooterInSection:section];
    }
    
    return 0.0f;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)] )
    {
        return [_secondDelegate tableView:tableView viewForHeaderInSection:section];
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)] )
    {
        return [_secondDelegate tableView:tableView viewForFooterInSection:section];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}


// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] )
    {
        [_secondDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)] )
    {
        [_secondDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}


// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate && [_secondDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }

    return @"删除";
}


// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }

    return YES;
}


// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)] )
    {
        [_secondDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)] )
    {
        [_secondDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}


// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)] )
    {
        [_secondDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    
    // is it right??
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath // return 'depth' of row for hierarchies
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    
    // is it right?
    return 0;
}


// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)] )
    {
        return [_secondDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)] )
    {
        return [_secondDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    
    return NO;
}


- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ((id)self != _secondDelegate &&  [_secondDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)] )
    {
        [_secondDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

//////////////////////////////////////////////
//
//      UIScrollViewDelegate 
//
//////////////////////////////////////////////


@end

@implementation UIPullingheaderGroupTableView

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (dataSource != nil) {
        super.dataSource = self;
    }
    _myDataSrouce = dataSource;
}
- (void)setDelegate:(id<UITableViewDelegate,UIPullingheaderDelegate>)delegate
{
    if (delegate != nil) {
        super.delegate = self;
    }
    _myDelegate = delegate;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray * indexs = [[NSMutableArray alloc] initWithCapacity:[indexPaths count]];
    for(NSIndexPath * path in indexPaths)
    {
        [indexs addObject:[NSIndexPath indexPathForRow:path.row+1 inSection:path.section]];
    }
    [super deleteRowsAtIndexPaths:indexs withRowAnimation:animation];
    
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray * indexs = [[NSMutableArray alloc] initWithCapacity:[indexPaths count]];
    for(NSIndexPath * path in indexPaths)
    {
        [indexs addObject:[NSIndexPath indexPathForRow:path.row+1 inSection:path.section]];
    }
    [super insertRowsAtIndexPaths:indexs withRowAnimation:animation];
    
}


//delegate
-(void)onInvokePullingRefresh:(UIPullingheaderTableView *)view
{
    [_myDelegate onInvokePullingRefresh:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= 0)
    {
        return [_myDelegate tableView:tableView heightForHeaderInSection:indexPath.section];
    }
    return [_myDelegate tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= 0)
    {
        return;
    }
    if(_myDelegate && [_myDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [_myDelegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
}


//datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_myDataSrouce && [_myDataSrouce respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
    {
        return [_myDataSrouce tableView:tableView numberOfRowsInSection:section] + 1;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= 0)
    {
        if([_myDelegate tableView:tableView heightForHeaderInSection:indexPath.section] <= 0)
        {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head_view_empty"] ;
        }
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head_view"] ;
		cell.backgroundColor = [UIColor clearColor];
//		cell.backgroundView = nil;
        UIView * headView = [_myDelegate tableView:tableView viewForHeaderInSection:indexPath.section];
        headView.center = CGPointMake(headView.frame.size.width/2, headView.frame.size.height/2);
        [cell addSubview:headView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [_myDataSrouce tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( [_myDelegate respondsToSelector:@selector(tableView: heightForFooterInSection:)] )
    {
        return [_myDelegate tableView:tableView heightForFooterInSection:section];
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( [_myDelegate respondsToSelector:@selector(tableView: viewForFooterInSection:)] )
    {
        return [_myDelegate tableView:tableView viewForFooterInSection:section];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_myDataSrouce && [_myDataSrouce respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [_myDataSrouce numberOfSectionsInTableView:tableView];
    }
    
    return 0;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ((id)self != _myDelegate &&  [_myDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)] ){
        
        [_myDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[self getRefreshView] egoRefreshScrollViewDidScroll:scrollView];
    
    if ((id)self != _myDelegate && [_myDelegate respondsToSelector:@selector(scrollViewDidScroll:)] ){
        [_myDelegate scrollViewDidScroll:scrollView];
    }
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[[self getRefreshView] egoRefreshScrollViewDidEndDragging:scrollView];

	if ((id)self != _myDelegate &&  [_myDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)] ){
        
        [_myDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
@end




