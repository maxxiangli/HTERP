//
//  CHContactList.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestJSONModelBase.h"
#import "CHCompanyCompent.h"

@interface CHContactList : CRequestJSONModelBase

@property(nonatomic, strong)NSArray<CHCompanyCompent, Optional> *contactList;

//排序使用
@property(nonatomic, strong)NSMutableArray<Ignore> *originalDataSource;
@property(nonatomic, strong)NSDictionary<Ignore> *allDataSource;

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)err;

@end
