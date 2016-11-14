//
//  CHContactsViewController.m
//  HTERP
//
//  Created by macbook on 11/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactsViewController.h"
#import "CHContactsModel.h"
#import "CHCompanyCompent.h"
#import "CHDeparment.h"
#import "CHContactBrowseViewController.h"
#import "CHUserDetailViewController.h"
#import "CHSearchContactViewController.h"
#import "CNavigationController.h"
#import "CHSearchContactMode.h"

@interface CHContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CHSearchContactViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)CHContactsModel *contactModel;
@property (nonatomic, assign)BOOL isOneCompany;
@property (nonatomic, strong)NSMutableArray *tmpList;


@end

@implementation CHContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人";
    
    self.contactModel = [[CHContactsModel alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private function
- (void)pushUserDetailViewController:(CHUser *)user
{
    UIStoryboard *storyBoard = nil;
    CHUserDetailViewController *userVC = nil;
    storyBoard = [UIStoryboard storyboardWithName:@"CHUserDetail" bundle:nil];
    userVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHUserDetail"];
    userVC.title = user.itemName;
    [self.navigationController pushViewController:userVC animated:YES];
}


#pragma mark - TableView datasourc and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contactModel.contactList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) //收藏等
    {
        NSArray *list = [self.contactModel.contactList firstObject];
        rows = [list count];
    }
    else
    {
        NSArray *list = [self.contactModel.contactList objectAtIndex:section];
        if ([list count] > 0)
        {
            if ([list count] == 1)
            {
                self.tmpList = [NSMutableArray arrayWithCapacity:8];
                
                CHCompanyCompent *company = [list firstObject];
                
                [self.tmpList addObject:company.companyInfo];
                rows += 1;

                if ([company.users count] > 0)
                {
                    [self.tmpList addObjectsFromArray:company.users];
                    rows += [company.users count];
                }
                
                if ([company.branchList count] > 0)
                {
                    [self.tmpList addObjectsFromArray:company.branchList];
                    rows += [company.branchList count];
                }
                
                self.isOneCompany = YES;
            }
            else
            {
                rows += [list count];
                
                self.isOneCompany = NO;
            }
        }
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellIdentify = @"cellIdentfy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    if (indexPath.section == 0)
    {
        NSArray *list = [self.contactModel.contactList firstObject];
        NSString *title = [list objectAtIndex:indexPath.row];
        cell.textLabel.text = title;
    }
    else if(indexPath.section == 1)
    {
        if (self.isOneCompany)
        {
            CHItem *item = [self.tmpList objectAtIndex:indexPath.row];
            cell.textLabel.text = item.itemName;
        }
        else
        {
            NSArray *companyList = [self.contactModel.contactList objectAtIndex:indexPath.section];
            CHCompanyCompent *company = [companyList objectAtIndex:indexPath.row];
            cell.textLabel.text = company.companyInfo.itemName;
        }
    }
    else
    {
        //Do nothing
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (self.isOneCompany)
        {
            NSArray *companyList = self.contactModel.contactList[1];
            CHCompanyCompent *company = [companyList firstObject];
            CHDeparment *deparment = nil;
            NSString *title = company.companyInfo.itemName;
            
            CHItem *item = self.tmpList[indexPath.row];
            CHContactType type = [item.itemType integerValue];
            
            if (type == CHContactCompanyInfo || type == CHContactDepartment)
            {
                if (type == CHContactDepartment)
                {
                    deparment = (CHDeparment *)item;
                    title = deparment.itemName;
                }
                
                UIStoryboard *storyBoard = nil;
                CHContactBrowseViewController *browserVC = nil;
                storyBoard = [UIStoryboard storyboardWithName:@"CHContactBrowse" bundle:nil];
                browserVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHContactBrowse"];
                browserVC.title = title;
                browserVC.company = company;
                browserVC.curDeparment = deparment;
                [self.navigationController pushViewController:browserVC animated:YES];
            }
            else if (type == CHContactUser)
            {
                CHUser *user = (CHUser *)item;
                [self pushUserDetailViewController:user];
            }
            else
            {
                //Do nothing
            }
        }
        else
        {
            NSArray *companyList = [self.contactModel.contactList objectAtIndex:indexPath.section];
            CHCompanyCompent *company = [companyList objectAtIndex:indexPath.row];
            UIStoryboard *storyBoard = nil;
            CHContactBrowseViewController *browserVC = nil;
            storyBoard = [UIStoryboard storyboardWithName:@"CHContactBrowse" bundle:nil];
            browserVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHContactBrowse"];
            browserVC.title = company.companyInfo.itemName;
            browserVC.company = company;
            [self.navigationController pushViewController:browserVC animated:YES];
        }
    }
}

#pragma mark - CHSearchContactViewController delegate
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

#pragma mark - UISearchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIStoryboard *storyBoard = nil;
    CHSearchContactViewController *searchVC = nil;
    storyBoard = [UIStoryboard storyboardWithName:@"CHSearchContact" bundle:nil];
    searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"CHSearchContact"];
    searchVC.delegate = self;
    searchVC.title = @"搜索联系人";
    
    CNavigationController *nav = [[CNavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    return NO;
}

@end
