//
//  CRequestJSONModelBase.m
//  QQStock
//
//  Created by zheliang on 14/11/21.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "CRequestJSONModelBase.h"
#import <objc/runtime.h>

@implementation CRequestJSONModelBase
-(id)init
{
	self = [super init];
	if (self) {
#ifdef DEBUG_PROFILE
        self.originData = nil;
        self.requestUrl = nil;
        
#endif
        self.code = nil;
        self.msg = nil;
	}
	return self;
}

- (void)dealloc
{
#ifdef DEBUG_PROFILE
    self.originData = nil;
    self.requestUrl = nil;
    
#endif
    self.code = nil;
	self.msg = nil;
	
	
}

-(instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)err
{

        id model = nil;
        Class currentClass = object_getClass(self);

        if (*err) {
            return nil;
        }
        @try {
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:err];

            model = [self initWithDictionary:jsonDic error:err];
            
        } @catch (NSException *exception) {
            
        } @finally {
            if (model && !*err)
            {
                return model;
            }
            else
            {
                //Safe_Release(self);			// 解析失败,构建CATradeDataResponseBaseModel对象获取信息
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:err];

                CRequestJSONModelBase *baseErrorModel = [[CRequestJSONModelBase alloc] initWithDictionary:jsonDic error:err ] ;
                //            ((CRequestJSONModelBase*)model).code = baseErrorModel.code;
                //            ((CRequestJSONModelBase*)model).msg = baseErrorModel.msg;
                //
                CRequestJSONModelBase* model = [[currentClass alloc]  init];
                model.code = baseErrorModel.code;
                model.msg = baseErrorModel.msg;
                return model;
            }
        }



	
}

-(instancetype)initWithString:(NSString *)jsonString error:(NSError *__autoreleasing *)err
{
    if (jsonString == nil) {
        return nil;
    }
    NSData* data = nil;
    @try {
        data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        return nil;
    }
    return [self initWithData:data error:err];
//
//	@try {
//		NSError* initError = nil;
//		NSDictionary* jsonDic = [jsonString objectFromJSONString];
//		if (!jsonDic) {
//			return nil;
//		}
//		id model = [super initWithDictionary:jsonDic error:&initError];
//		if (initError && err) *err = initError;
//		
//		if (model && !initError)
//		{
//			return model;
//		}
//		else
//		{
//            // 解析失败,构建CATradeDataResponseBaseModel对象获取信息
//            NSError *baseError = nil;
//            CRequestJSONModelBase *baseErrorModel = [[CRequestJSONModelBase alloc] initWithDictionary:jsonDic error:&baseError ] ;
//            ((CRequestJSONModelBase*)model).code = baseErrorModel.code;
//            ((CRequestJSONModelBase*)model).msg = baseErrorModel.msg;
//            
//            return model;
//		}
//	}
//	@catch (NSException *exception) {
//        // 解析失败,构建CATradeDataResponseBaseModel对象获取信息
//        NSError *baseError = nil;
//        id model = [self init];
//        NSDictionary* jsonDic = [jsonString objectFromJSONString];
//        
//        CRequestJSONModelBase *baseErrorModel = [[CRequestJSONModelBase alloc] initWithDictionary:jsonDic error:&baseError ] ;
//        ((CRequestJSONModelBase*)model).code = baseErrorModel.code;
//        ((CRequestJSONModelBase*)model).msg = baseErrorModel.msg;
//        
//        return model;
//	}
	
}
+(BOOL)propertyIsIgnored:(NSString *)propertyName
{
	if ([propertyName isEqualToString: @"resultDataType"]) return YES;
	return NO;
}

@end
