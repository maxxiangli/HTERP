//
//  NSDictionary+Extra.h
//  QQStock
//
//  Created by zheliang on 14/12/9.
//  Copyright (c) 2014年 zheliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extra)
-(NSArray*) to_array ;
-(BOOL) hasKey:(id)key ;
-(id) keyForObject:(id)obj ;
@end


@interface NSDictionary (CapitalizedExt)
-(id) Fetch:(id)key ;
-(NSArray*) Keys ;
-(NSArray*) Values ;
@end

@interface NSMutableDictionary (Extra)

-(id) storeKey:(id)key value:(id)value ;
-(void) merge:(NSDictionary*)other ;
-(id) delete:(id)key ;
-(void) clear ;
- (void)setObject_s:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)removeObjectForKey_s:(id)aKey;
@end