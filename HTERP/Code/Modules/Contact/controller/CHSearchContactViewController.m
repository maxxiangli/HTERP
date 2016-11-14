//
//  CHSearchContactViewController.m
//  HTERP
//
//  Created by macbook on 13/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHSearchContactViewController.h"
#import "CHContactListManager.h"
#import "CHSearchContactMode.h"
#import "ZYPinYinSearch.h"
#import "CHContactList.h"
#import "CHSortString.h"

@interface CHSearchContactViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation CHSearchContactViewController

- (void)dealloc
{
    _searchBar.delegate = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildRightItem];
    
    self.searchBar.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private function
- (void)buildRightItem
{
    CCustomButton *cancleButton = [CCustomButton buttonWithTitle:@"取消" style:eCustomButtonStyleSquare];
    [cancleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [cancleButton addTarget:self action:@selector(handleCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

- (void)makeSearchResult:(NSArray *)result
{
    if (!result || [result count] == 0)
    {
        return;
    }
    
    //公司分组
    NSMutableArray *companyIds = [NSMutableArray arrayWithCapacity:16];
    for (CHSearchContactMode *mode in result)
    {
        if (![companyIds containsObject:mode.companyId])
        {
            [companyIds addObject:mode.companyId];
        }
    }
    
    for (NSString *cid in companyIds)
    {
        @autoreleasepool {
            NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:16];
            for (CHSearchContactMode *mode in result)
            {
                if ([cid isEqualToString:mode.companyId])
                {
                    [tmp addObject:mode];
                }
            }
            
            if ([tmp count] > 0 )
            {
                [self.searchResult addObject:tmp];
            }
        }
    }
}

#pragma mark - UITable delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.searchResult count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = self.searchResult[section];
    return [rows count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *rows = self.searchResult[section];
    CHSearchContactMode *mode = [rows firstObject];
    return mode.companyName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentify = @"searchcellIdentify";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    NSArray *rows = self.searchResult[indexPath.section];
    CHSearchContactMode *mode = rows[indexPath.row];
    cell.textLabel.text = mode.userName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *users = self.searchResult[indexPath.section];
    CHSearchContactMode *mode = users[indexPath.row];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(searchController:didSelectedUsers:)])
    {
        NSArray *selectedUsers = [NSArray arrayWithObject:mode];
        [self.delegate searchController:self didSelectedUsers:selectedUsers];
    }
}


#pragma mark - Property function
- (NSMutableArray *)searchResult
{
    if (!_searchResult)
    {
        _searchResult = [NSMutableArray arrayWithCapacity:16];
    }
    return _searchResult;
}

#pragma mark - UISearchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"==========%@", searchText);
    
    [self.searchResult removeAllObjects];
    
    NSArray *results = nil;
    CHContactList *list = [[CHContactListManager defaultManager] contactsList];
    NSMutableArray *values = [CHSortString getAllValuesFromDict:list.allDataSource];
    
    if (searchBar.text.length == 0)
    {
        // Do nothing
    }
    else
    {
        results = [ZYPinYinSearch searchWithOriginalArray:values
                                            andSearchText:searchText
                                  andSearchByPropertyName:@"userName"];
        if ([results count] > 0)
        {
            [self makeSearchResult:results];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)handleCancelClick:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self.searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //Do noting
    }];
}

#pragma mark - Public function
- (void)resignSearchBarFirstResponder
{
    [self.searchBar resignFirstResponder];
}

@end
