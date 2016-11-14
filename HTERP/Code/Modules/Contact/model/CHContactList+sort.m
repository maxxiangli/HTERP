//
//  CHContactList+sort.m
//  HTERP
//
//  Created by macbook on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactList+sort.h"
#import "CHSearchContactMode.h"
#import "CHSortString.h"

@implementation CHContactList (sort)

- (void)prepareForSort
{
    for (CHCompanyCompent *company in self.contactList)
    {
        NSString *companyId = company.companyInfo.itemId;
        NSString *companyName = company.companyInfo.itemName;
        if (company.users && [company.users count] > 0)
        {
            for (CHUser *user in company.users)
            {
                CHSearchContactMode *mode = [[CHSearchContactMode alloc] init];
                mode.companyId = companyId;
                mode.companyName = companyName;
                mode.userName = user.itemName;
                mode.user = user;
                
                NSLog(@"cid = %@ - uid = %@ name = %@", companyId, companyName, user.itemId);
                
                [self.originalDataSource addObject:mode];
            }
        }
        
        if (company.branchList && [company.branchList count] > 0)
        {
            [self makeOriginDataSource:company.branchList
                             companyId:companyId
                           companyName:companyName];
        }
    }
    
    if (self.originalDataSource && [self.originalDataSource count] > 0)
    {
        NSArray *dataSource = [self.originalDataSource copy];
        NSMutableDictionary *dic = [CHSortString sortAndGroupForArray:dataSource PropertyName:@"userName"];
        self.allDataSource = [dic copy];
    }
}

- (void)makeOriginDataSource:(NSArray *)deparments
                   companyId:(NSString *)companyId
                 companyName:(NSString *)companyName
{
    for (CHDeparment *deparment in deparments)
    {
        if (deparment.users && [deparment.users count] > 0)
        {
            for (CHUser *user in deparment.users)
            {
                CHSearchContactMode *mode = [[CHSearchContactMode alloc] init];
                mode.companyId = companyId;
                mode.companyName = companyName;
                mode.userName = user.itemName;
                mode.user = user;
                
                NSLog(@"uid = %@ id = %@ name = %@",companyName, user.itemId, user.itemName);
                
                [self.originalDataSource addObject:mode];
            }
        }
        
        if (deparment.deparments && [deparment.deparments count] > 0)
        {
            [self makeOriginDataSource:deparment.deparments
                             companyId:companyId
                           companyName:companyName];
        }
    }
}

@end
