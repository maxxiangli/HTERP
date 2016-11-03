//
//  CRequestJSONModelBase.h
//  QQStock
//
//  Created by zheliang on 14/11/21.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "CJSONModel.h"
@protocol NSString

@end
@interface CRequestJSONModelBase : CJSONModel
#ifdef DEBUG_PROFILE
@property (nonatomic,copy)			NSString<Ignore>*		originData;
@property (nonatomic,copy)			NSString<Ignore>*		requestUrl;

#endif

@property (nonatomic,copy)			NSString*				code;
@property (nonatomic,copy)			NSString*				msg;
-(instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)err;
-(instancetype)initWithString:(NSString *)jsonString error:(NSError *__autoreleasing *)err;

@end
