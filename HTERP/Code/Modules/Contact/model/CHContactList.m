//
//  CHContactList.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactList.h"

@implementation CHContactList

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)err
{
    self = [super initWithData:data error:err];
    if (self)
    {
        //Do nothing
    }
    return self;
}

- (NSMutableArray *)originalDataSource
{
    if (!_originalDataSource)
    {
        _originalDataSource = [NSMutableArray arrayWithCapacity:32];
    }
    return _originalDataSource;
}

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *info = @{@"contactList":@"data"};
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:info];
    return mapper;
}

@end
