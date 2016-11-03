#import "NSObject+Json.h"

@implementation NSObject (JsonEncode)

- (NSString *)JSONSerializer {
	NSError* error = nil;
	NSData* data = [NSJSONSerialization dataWithJSONObject:self
												   options:kNilOptions error:&error];
	if (error != nil) {
		return nil;
	}
	NSString* result = [[NSString alloc]initWithData:data
											 encoding:NSUTF8StringEncoding];

	return result;
}

@end

@implementation NSString (JsonDecode)

- (BOOL)dataContainNull:(id)data
{
    if(nil == data)
    {
        return NO;
    }
    if([data isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if([data isKindOfClass:[NSDictionary class]])
    {
        for(id element in [data allValues])
        {
            if([self dataContainNull:element])
            {
                return YES;
            }
        }
    }
    if([data isKindOfClass:[NSArray class]])
    {
        for(id element in data)
        {
            if([self dataContainNull:element])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (id)JSONObjectWithFunction:(const char *)function
{
    id result = nil;
    @try {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        if (error != nil) {
            result = nil;
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSString * msg = [NSString stringWithFormat:@"jsonDataError:%s",function];
        [[NSNotificationCenter defaultCenter] postNotificationName:STOCK_NOTICE_JSON_DECODE_ERROR object:nil userInfo:[NSDictionary dictionaryWithObject:msg forKey:@"msg"]];
        return nil;
    }

    
    //防止服务器数据异常导致crash
#if ENABLE_JSON_NULL_CHECK
    if([self dataContainNull:result])
    {
        NSString * msg = [NSString stringWithFormat:@"jsonDataNULL:%s",function];
        [[NSNotificationCenter defaultCenter] postNotificationName:STOCK_NOTICE_JSON_DECODE_NULL object:nil userInfo:[NSDictionary dictionaryWithObject:msg forKey:@"msg"]];
        
        return nil;
    }
#endif
    
    return result;
}

@end
