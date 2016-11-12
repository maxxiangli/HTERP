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

@interface CHContactBrowseViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createDataList];
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
        
        [self.selectedItem addObject:self.curDeparment];
        
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




@end
