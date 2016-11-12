//
//  CHContactsModel.m
//  HTERP
//
//  Created by macbook on 11/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactsModel.h"
#import "CHContactList.h"
#import "CHContactListManager.h"

@interface CHContactsModel()

@end

@implementation CHContactsModel

- (void)dealloc
{
    //Do nothing
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //Do nothing
    }
    return self;
}

- (NSArray *)contactList
{
    if (!_contactList)
    {
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:8];
        NSArray *array = @[@"收藏联系人", @"收藏群组"];
        [list addObject:array];
        
        CHContactList *contacts = [[CHContactListManager defaultManager] contactsList];
        if (contacts && contacts.contactList)
        {
            [list addObject:contacts.contactList];
        }
        
        _contactList = [list copy];
    }
    
    return _contactList;
}




@end
