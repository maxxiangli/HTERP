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

@interface CHContactsViewController ()<UITableViewDelegate, UITableViewDataSource>
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
            }else if (type == CHContactUser)
            {
                
            }else
            {
                //Do nothing
            }
            
            

            
            NSLog(@"item type = %@", item.itemType);
            UIStoryboard *browseStoryBoard = [UIStoryboard storyboardWithName:@"CHContactBrowse" bundle:nil];
            CHContactsViewController *contactViewController = [browseStoryBoard instantiateViewControllerWithIdentifier:@"CHContactBrowse"];
            contactViewController.title = item.itemName;
            [self.navigationController pushViewController:contactViewController animated:YES];
        }
        else
        {
            NSArray *companyList = [self.contactModel.contactList objectAtIndex:indexPath.section];
            CHItem *item = [companyList objectAtIndex:indexPath.row];
            NSLog(@"item type = %@", item.itemType);
        }
    }
}


@end
