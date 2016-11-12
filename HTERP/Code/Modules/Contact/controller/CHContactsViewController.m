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
    NSInteger count = [self.contactModel.contactList count];
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
                rows += 1;
                rows += [company.users count];
                rows += [company.branchList count];
                
                [self.tmpList addObject:company.companyInfo];
                if ([company.users count] > 0)
                {
                    [self.tmpList addObjectsFromArray:company.users];
                }
                
                if ([company.branchList count] > 0)
                {
                    [self.tmpList addObjectsFromArray:company.branchList];
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
    else
    {
        if (self.isOneCompany)
        {
            id obj = [self.tmpList objectAtIndex:indexPath.row];
            if ([obj isKindOfClass:[CHCompanyInformation class]])
            {
                CHCompanyInformation *info = (CHCompanyInformation *)[self.tmpList objectAtIndex:indexPath.row];
                cell.textLabel.text = info.name;
            }
            else if ([obj isKindOfClass:[CHDeparment class]])
            {
                CHDeparment *info = (CHDeparment *)[self.tmpList objectAtIndex:indexPath.row];
                cell.textLabel.text = info.name;
            }
            else if ([obj isKindOfClass:[CHUser class]])
            {
                CHUser *user = (CHUser *)[self.tmpList objectAtIndex:indexPath.row];
                cell.textLabel.text = user.name;
            }
            else{
                //Do nothing
            }
        }
        else
        {
            
        }
    }
    
    return cell;
}


@end
