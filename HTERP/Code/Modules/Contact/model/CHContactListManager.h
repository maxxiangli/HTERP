//
//  CHContactListManager.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

@class CHContactList;

#import <Foundation/Foundation.h>

@interface CHContactListManager : NSObject

+ (CHContactListManager *)defaultManager;

- (void)startFetchingContactList;

- (void)stopFetchingContactList;

- (CHContactList *)contactsList;

@end
