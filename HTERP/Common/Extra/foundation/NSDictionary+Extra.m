//
//  NSDictionary+Extra.m
//  QQStock
//
//  Created by zheliang on 14/12/9.
//  Copyright (c) 2014年 zheliang. All rights reserved.
//

#import "NSDictionary+Extra.h"

@implementation NSDictionary (Extra)

-(NSArray*) to_array {
    NSMutableArray* ary = [NSMutableArray array];
    for (id key in [self allKeys]) {
        id value = [self valueForKey:key];
        [ary addObject:@[key, value]];
    }
    return ary;
}

-(BOOL) hasKey:(id)key {
    NSEnumerator* enumerator = [self keyEnumerator];
    id k;
    while ((k = [enumerator nextObject])) {
        if ([k isEqual:key]) {
            return true;
        }
    }
    return false;
}

-(id) keyForObject:(id)obj {
    NSEnumerator* enumerator = [self keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id objectForKey = [self objectForKey:key];
        if ([objectForKey isEqual:obj]) {
            return key;
        }
    }
    return nil;
}

@end



@implementation NSDictionary (CapitalizedExt)



-(id) Fetch:(id)key {
    return [self objectForKey:key];
}
-(NSArray*) Keys {
    return [self allKeys];
}

-(NSArray*) Values {
    return [self allValues];
}


@end


@implementation NSMutableDictionary (Extra)
- (void)setObject_s:(id)anObject forKey:(id<NSCopying>)aKey{
    [self storeKey:aKey value:anObject];
}

- (void)removeObjectForKey_s:(id)aKey
{
    if (aKey) {
        [self delete:aKey];
    }
}

-(id) storeKey:(id)key value:(id)value {
    if (!key || !value) {
        return nil;
    }
    [self setObject:value forKey:key];
    return value;
}

-(void) merge:(NSDictionary*)other {
    [self addEntriesFromDictionary:other];
}

-(id) delete:(id)key {
    if (!key) {
        return nil;
    }
    id obj = [self objectForKey:key];
    [self removeObjectForKey:key];
    return obj;
}

-(void) clear {
    [self removeAllObjects];
}

@end