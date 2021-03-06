//
//  CHContactListManager.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactListManager.h"
#import "CHContactList.h"
#import "CHGetCompanyParams.h"
#import "CHGlobalDefine.h"
#import "CLoginStateJSONRequestCommand.h"
#import "CHFetchContactRequestCommand.h"
#import "HTLoginManager.h"
#import "CLoginInforModel.h"

@interface CHContactListManager()

@property(nonatomic, strong)CHContactList *contactsList;
@property(nonatomic, strong)CHFetchContactRequestCommand *requestComment;

@end

@implementation CHContactListManager

+ (CHContactListManager *)defaultManager
{
    static CHContactListManager *listManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        listManager = [[CHContactListManager alloc] init];
    });
    
    return listManager;
}

- (void)startFetchingContactList
{
    if (self.requestComment)
    {
        [self.requestComment stopRequest];
        self.requestComment = nil;
    }
    
    CLoginInforModel *loginInfor = [HTLoginManager getInstance].loginInfor;
    CHGetCompanyParams *postParams = [[CHGetCompanyParams alloc] init];
    postParams.userId = loginInfor.userId ? loginInfor.userId : @"1479369785138084301";
    
    __weak typeof(self) weakSelf = self;
    self.requestComment = [CHFetchContactRequestCommand postWithParams:postParams
                                                           modelClass:[CHContactList class]
                                                               sucess:^(NSInteger code,
                                                                       NSString *msg,
                                                                       CJSONRequestCommand *requestCommand)
                           {
                               NSLog(@"code = %@ msg = %@", @(code), msg);
                               weakSelf.contactsList = (CHContactList *)requestCommand.responseModel;
                               [weakSelf postContactsUpdateNotification];
                               
                           } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
                               NSLog(@"dataParseError = %@", dataParseError);
                               NSLog(@"code = %@ msg = %@", @(code), msg);
                           }];
    
}

- (void)stopFetchingContactList
{
    if (self.requestComment)
    {
        [self.requestComment stopRequest];
        self.requestComment = nil;
    }
}

- (CHContactList *)contactsList
{
    return _contactsList;
}

#pragma mark - Private function
- (void)postContactsUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CHUpdateContactsNotification object:nil];
}

@end
