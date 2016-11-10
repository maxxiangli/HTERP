//
//  HTLoginManager.h
//  HTERP
//
//  Created by li xiang on 16/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLoginManager : NSObject
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *session;
@property(nonatomic, copy) NSString *phoneNum;

- (BOOL)isLogin;
@end
