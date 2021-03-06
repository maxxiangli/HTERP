//
//  CHContactBrowseViewController.m
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactBrowseViewController.h"
#import "CHNameBrowseView.h"
#import "CHUserDetailViewController.h"
#import "CHSearchContactViewController.h"
#import "CNavigationController.h"
#import "CHSearchContactMode.h"

@interface CHContactBrowseViewController ()<UITableViewDelegate, UITableViewDataSource, CHNameBrowseViewDelegate, UISearchBarDelegate, CHSearchContactViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet CHNameBrowseView *browseView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *selectedItem;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CHContactBrowseViewController

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _browseView.delegate = nil;
    _searchBar.delegate = nil;
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.browseView.delegate = self;
    
    self.searchBar.delegate = self;
    
    [self.selectedItem removeAllObjects];
    
    [self createDataList];
    [self updateNameBrowseView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self updateNameBrowseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private function
- (void)createDataList
{
    [self.dataList removeAllObjects];
    
    if (self.curDeparment)
    {
        if ([self.selectedItem count] == 0)
        {
            [self.selectedItem addObject:self.company];
        }
        
        if (![self.selectedItem containsObject:self.curDeparment])
        {
            [self.selectedItem addObject:self.curDeparment];
        }
        
        NSArray *users = self.curDeparment.users;
        if (users && [users count] > 0)
        {
            [self.dataList addObjectsFromArray:users];
        }
        
        NSArray *deparments = self.curDeparment.deparments;
        if (deparments && [deparments count] > 0)
        {
            [self.dataList addObjectsFromArray:deparments];
        }
    }
    else
    {
        if (self.company)
        {
            if ([self.selectedItem count] == 0)
            {
                [self.selectedItem addObject:self.company];
            }
            
            NSArray *users = self.company.users;
            if (users && [users count] > 0)
            {
                [self.dataList addObjectsFromArray:users];
            }
            
            NSArray *deparments = self.company.branchList;
            if (deparments && [deparments count] > 0)
            {
                [self.dataList addObjectsFromArray:deparments];
            }
        }
    }
}

- (void)pushUserDetailViewController:(CHUser *)user
{
    UIStoryboard *storyBoard = nil;
    CHUserDetailViewController *userVC = nil;
    storyBoard = [UIStoryboard storyboardWithName:@"CHUserDetail" bundle:nil];
    userVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHUserDetail"];
    userVC.title = user.itemName;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)updateNameBrowseView
{
    for (CHItem *item in self.selectedItem)
    {
        if ([item isKindOfClass:[CHCompanyCompent class]])
        {
            CHCompanyCompent *company = (CHCompanyCompent *)item;
            if (company.companyInfo.itemName)
            {
                [self.browseView addText:company.companyInfo.itemName];
            }
        }
        else if ([item isKindOfClass:[CHDeparment class]])
        {
            [self.browseView addText:item.itemName];
        }
        else{
            //Do nothing
        }
    }
}

#pragma mark - Property
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray arrayWithCapacity:16];
    }
    return _dataList;
}

- (NSMutableArray *)selectedItem
{
    if (!_selectedItem)
    {
        _selectedItem = [NSMutableArray arrayWithCapacity:16];
    }
    return _selectedItem;
}

#pragma mark - TableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentify = @"cellIdentify";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    CHItem *item = self.dataList[indexPath.row];
    cell.textLabel.text = item.itemName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CHItem *item = self.dataList[indexPath.row];
    CHContactType type = [item.itemType integerValue];
    if (type == CHContactDepartment)
    {
        CHDeparment *deparment = (CHDeparment *)item;
        self.curDeparment = deparment;
        self.title = self.curDeparment.itemName;
        [self createDataList];
        [self.tableView reloadData];
        [self.browseView addText:deparment.itemName];
    }
    else if (type == CHContactUser)
    {
        //Go to detail
        CHUser *user = (CHUser *)item;
        [self pushUserDetailViewController:user];
    }
    else
    {
        //Do nothing
    }
}

#pragma mark - CHNameBrowseView delegate
- (void)browseView:(CHNameBrowseView *)browseView didSelectedIndex:(NSInteger)index
{
    if ((index + 1 ) == [self.selectedItem count])
    {
        return;
    }
    
    NSRange range = NSMakeRange(index + 1, [self.selectedItem count] - 1 - index);
    [self.selectedItem removeObjectsInRange:range];
    [browseView removeTextAfterIndex:index];
    
    CHItem *item = [self.selectedItem lastObject];
    if ([item isKindOfClass:[CHCompanyCompent class]])
    {
        self.curDeparment = nil;
        [self createDataList];
        [self.tableView reloadData];
    }
    else if ([item isKindOfClass:[CHDeparment class]])
    {
        CHDeparment *deparment = (CHDeparment *)item;
        self.curDeparment = deparment;
        [self createDataList];
        [self.tableView reloadData];
    }
    else
    {
        //Do nothing
    }
}

#pragma mark - UISearchBar delegage
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIStoryboard *storyBoard = nil;
    CHSearchContactViewController *searchVC = nil;
    storyBoard = [UIStoryboard storyboardWithName:@"CHSearchContact" bundle:nil];
    searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHSearchContact"];
    searchVC.title = @"搜索联系人";
    searchVC.delegate = self;
    
    CNavigationController *nav = [[CNavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    return NO;
}

#pragma mark - CHSearchContactViewControllerDelegate
- (void)searchController:(CHSearchContactViewController *)searchController didSelectedUsers:(NSArray *)users
{
    [searchController resignSearchBarFirstResponder];
    
    __weak typeof(self) selfWeak = self;
    [searchController dismissViewControllerAnimated:NO completion:^{
        
        CHSearchContactMode *mode = [users firstObject];
        CHUser *user = mode.user;
        [selfWeak pushUserDetailViewController:user];
        
    }];
}

@end
