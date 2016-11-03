//
//  CRequestParams.m
//  QQStock
//
//  Created by zheliang on 15/2/3.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CRequestParams.h"
#import <objc/runtime.h>


@implementation CRequest

+ ( NSString*)generatorGetRequestURLWithParams:(CRequestBaseParams*)params
{
    NSString    *paramsString       = [params paramString];
    NSString    *fullURL            = nil;
        
    fullURL = [NSString stringWithFormat:@"%@?%@", [[self class] generatorRequestURL:params], paramsString];

    
    Info(@"URL:%@", fullURL);
    
    return fullURL;
} /* generatorFullURLWithParams */

+ ( NSString*)generatorRequestURL:(CRequestBaseParams*)params
{
    NSString    *requestURL             = nil;
    NSString    *path                   = [[params class] path];

    requestURL = [NSString stringWithFormat:@"%@%@", [[params class] serverAddress], path];
        
    return requestURL;
}/* generatorRequestURL */
@end

@implementation CRequestBaseParams
{
}
+ (NSString *)serverAddress
{
    NSAssert(NO, @"子类必须实现");
    return  nil;
}
+ (NSString *)path
{
    NSAssert(NO, @"子类必须实现");
    return nil;
}

- (NSString*)paramString
{
    
    
    
    if ([self respondsToSelector:@selector(updateDynamicValue)])
    {
        [self updateDynamicValue];
    }
    
    NSMutableString     *result     = [[NSMutableString alloc] initWithCapacity:128] ;
    bool                firstParam  = YES;
    Class class = [self class];
    
    while (class != [CRequestBaseParams class]) {
        //*****遍历属性的实现方式
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            //get property name
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            if ([[self class] respondsToSelector:@selector(propertyIsIgnored:)] && [[self class] propertyIsIgnored:@(propertyName)]) {
                continue;
            }
            id          value       = [(NSObject*)self valueForKeyPath : @(propertyName)];
            
            if (!value || [value isKindOfClass:[NSNull class]])
            {
                continue;
            }
            
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]])
            {
            }
            else
            {
                
                if ([[self class] respondsToSelector:@selector(stringDescriptionForObject:)])
                {
                    value = [[self class] stringDescriptionForObject:value];
                }
                else
                {
                    value = @"unknown-data";
                }
            }
            
            NSString  *param = nil;
            
            if (firstParam)
            {
                param       = [NSString stringWithFormat:@"%@=%@", @(propertyName), value];
                firstParam  = NO;
            }
            else
            {
                param = [NSString stringWithFormat:@"&%@=%@", @(propertyName), value];
            }
            
            [result appendString:[param stringByUTF8Escape]];
        }
        class = [class superclass];
        free(properties);
        
    }
    return result;
} /* paramString */

- (NSDictionary *)paramDictionary
{
    
    
    if ([self respondsToSelector:@selector(updateDynamicValue)])
    {
        [self updateDynamicValue];
    }
    NSMutableDictionary     *result = nil;
    result     = [[NSMutableDictionary alloc] initWithCapacity:0x1] ;
    
    Class class = [self class];
    
    while (class != [CRequestBaseParams class]) {
        //*****遍历属性的实现方式
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            //get property name
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            if ([[self class] respondsToSelector:@selector(propertyIsIgnored:)] && [[self class] propertyIsIgnored:@(propertyName)]) {
                continue;
            }
            id          value       = [(NSObject*)self valueForKeyPath : @(propertyName)];
            
            //如果无value 不加进请求
            if (!value || [value isKindOfClass:[NSNull class]])
            {
                
                continue;
//                value = @"";
            }
            
            if ([value isKindOfClass:[NSString class]])
            {
            }
            else if ([value isKindOfClass:[NSNumber class]])
            {
                value = [((NSNumber*)value) stringValue];
            }
            else if ([value isKindOfClass:[NSData class]])
            {
//                value = [((NSNumber*)value) stringValue];
            }
            else
            {
                
                if ([[self class] respondsToSelector:@selector(stringDescriptionForObject:)])
                {
                    value = [[self class] stringDescriptionForObject:value];
                }
                else
                {
                    value = @"unknown-data";
                }
            }
            
            
            [result setObject:value forKey:@(propertyName)];
        }
        class = [class superclass];
        free(properties);
        
        
    }
    
    return result;
}

@end
