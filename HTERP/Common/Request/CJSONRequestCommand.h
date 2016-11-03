//
//  CJSONRequestCommand.h
//  QQStock
//
//  Created by zheliang on 14/12/17.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "CRequestJSONModelBase.h"
#import "CRequestParams.h"
#import "CRequestCommand.h"

@class CJSONRequestCommand;

typedef void (^sucessHandler)(NSInteger code, NSString* msg, CJSONRequestCommand* requestCommand);
typedef void (^failureHandler)(NSInteger code, NSString* msg, CJSONRequestCommand* requestCommand, NSError* dataParseError);


@protocol CJSONRequestCommandDelegate <NSObject>

@optional

//return YES,不需要底层统一处理错误
//return NO, 错误交给底层处理。
//一般返回YES.
- (BOOL) requestErrored:(CJSONRequestCommand*)requestCommand;
@required
- (void) requestComplete:(CJSONRequestCommand*)requestCommand;

@end
@interface CJSONRequestCommand : CRequestCommand<CRequestCommandDelegate>

@property (nonatomic,assign)		  NSInteger						requestTag;     //请求标记
@property (nonatomic,assign)		  NSInteger                     requestType;    //请求类型
@property (nonatomic,retain)          CRequestJSONModelBase*        responseModel;  //请求返回的数据
#ifdef DEBUG_PROFILE
@property (nonatomic,retain)          NSString                      *originalData;  //原始数据
@property (nonatomic,retain)          NSString                      *requestUrl;    //请求的url
#endif
@property (nonatomic,retain)          Class                         modelClass;     //与数据解析相对于的model
@property (nonatomic,retain)          CRequestBaseParams*           params;         //请求参数
@property (nonatomic,weak)          id<CJSONRequestCommandDelegate> jsonDelegate;
@property (nonatomic, copy) sucessHandler success;
@property (nonatomic, copy) failureHandler failure;
- (id) initWithDelegate:(id<CJSONRequestCommandDelegate>)delegate modelClass:(Class)modelClass;
- (void)getWithParams:(CRequestBaseParams*)params;
- (void)postWithParams:(CRequestBaseParams*)params;
- (void)getWithParams:(CRequestBaseParams*)params header:(NSDictionary*)header;
- (void)postWithParams:(CRequestBaseParams*)params header:(NSDictionary*)header;
- (void)postData:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header;
- (void)getWithParams:(CRequestBaseParams *)params postOtherParams:(NSDictionary *)postParams header:(NSDictionary *)header;

+ (instancetype)getWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass sucess:(sucessHandler)sucess failure:(failureHandler)failure;
+ (instancetype)postWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass sucess:(sucessHandler)sucess failure:(failureHandler)failure;
+ (instancetype)getWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure;
+ (instancetype)postWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure;
+ (instancetype)postData:(Class)modelClass URL:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure;

+ (instancetype)getWithParams:(CRequestBaseParams *)params modelClass:(Class)modelClass postOtherParams:(NSDictionary *)postParams header:(NSDictionary *)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure;
@end
