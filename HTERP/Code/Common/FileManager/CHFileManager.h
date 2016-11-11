//
//  Util.h
//  QQMobileMap
//
//  Created by Nopwang on 11-3-4.
//  Copyright 2011 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHFileManager : NSObject {

    NSString* documentDirectory_;
    NSString* rootDirectory_;
}

@property (nonatomic, copy) NSString* documentDirectory;
@property (nonatomic, copy) NSString* rootDirectory;

+ (CHFileManager *)defaultManager;

//联系人存储目录
- (NSString *)contactsPath:(NSString *)userId;

@end
