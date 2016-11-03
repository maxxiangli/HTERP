//
//  CJSONRequestCommand.m
//  QQStock
//
//  Created by zheliang on 14/12/17.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "CJSONRequestCommand.h"

@interface CJSONRequestCommand()
{
    NSError* _dataParseError;
}



@end

@implementation CJSONRequestCommand

+ (instancetype)getWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand getWithParams:params];
    return requestCommand;
}

+ (instancetype)postWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand postWithParams:params];
    return requestCommand;

}

+ (instancetype)getWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand getWithParams:params header:header];
    return requestCommand;

}

+ (instancetype)postWithParams:(CRequestBaseParams*)params modelClass:(Class)modelClass header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand postWithParams:params header:header];
    return requestCommand;
}

+ (instancetype)postData:(Class)modelClass URL:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand postData:url postData:postData header:header];
    return requestCommand;
}

+ (instancetype)getWithParams:(CRequestBaseParams *)params modelClass:(Class)modelClass postOtherParams:(NSDictionary *)postParams header:(NSDictionary *)header  sucess:(sucessHandler)sucess failure:(failureHandler)failure
{
    CJSONRequestCommand* requestCommand = [[[self class] alloc] init];
    requestCommand.success = sucess;
    requestCommand.failure = failure;
    requestCommand.modelClass = modelClass;
    [requestCommand getWithParams:params postOtherParams:postParams header:header];
    return requestCommand;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        _dataParseError = nil;
    }
    return self;
}
-(id)initWithDelegate:(id<CJSONRequestCommandDelegate>)delegate modelClass:(Class)modelClass
{
    if (self = [super initWithDelegate:self]) {
        self.jsonDelegate = delegate;
        self.modelClass = modelClass;
        _dataParseError = nil;

    }

    return self;
}

- (void)getWithParams:(CRequestBaseParams*)params
{
    [self getWithParams:params header:nil];
}

- (void)getWithParams:(CRequestBaseParams*)params header:(NSDictionary*)header
{
    NSString *   URL     = [[CRequest generatorGetRequestURLWithParams:params] stringByUTF8Escape];
    self.params = params;
    _dataParseError = nil;

    [self startRequest:URL postData:nil header:header];
#ifdef DEBUG_PROFILE
    self.requestUrl = [self getRequestUrlForTest];
#endif
}

- (void)postWithParams:(CRequestBaseParams*)params
{
    [self postWithParams:params header:nil];
}

- (void)postWithParams:(CRequestBaseParams*)params header:(NSDictionary*)header{
    NSString *   URL     = [[CRequest generatorRequestURL:params] stringByUTF8Escape];
    Info(@"URL=====%@",URL);

    NSDictionary *result = [params paramDictionary];
    Info(@"params=====%@",result);
    self.params = params;
    _dataParseError = nil;

    [self startRequest:URL postData:result header:header];
#ifdef DEBUG_PROFILE
    self.requestUrl = [self getRequestUrlForTest];
#endif
}

- (void)postData:(NSString *)url postData:(NSDictionary *)postData header:(NSDictionary *)header
{
    Info(@"URL=====%@",url);

    Info(@"params=====%@",postData);
    self.params = nil;
    _dataParseError = nil;

    [self startRequest:url postData:postData header:header];
#ifdef DEBUG_PROFILE
    self.requestUrl = [self getRequestUrlForTest];
#endif
}

- (void)getWithParams:(CRequestBaseParams *)params postOtherParams:(NSDictionary *)postParams header:(NSDictionary *)header
{
    NSString *   URL     = [[CRequest generatorGetRequestURLWithParams:params] stringByUTF8Escape];
    Info(@"URL=====%@",URL);

    self.params = params;
    _dataParseError = nil;

    [self startRequest:URL postData:postParams header:header];
    
#ifdef DEBUG_PROFILE
    self.requestUrl = [self getRequestUrlForTest];
#endif
}

- (void)dealloc
{
    self.jsonDelegate = nil;
#ifdef DEBUG_PROFILE
    Safe_Release(_originalData);
    Safe_Release(_requestUrl);
#endif
    Safe_Release(_responseModel);
    Safe_Release(_modelClass);
    Safe_Release(_params);
    
}

- (void)setDelegate:(id<CRequestCommandDelegate>)delegate
{
    [super setDelegate:delegate];
    if (delegate == nil) {
        self.jsonDelegate = nil;

    }
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

-(void)parserDataInThread:(NSData *)recvData
{
#ifdef DEBUG_PROFILE

    NSString *string = [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
    self.originalData = [CJSONRequestCommand replaceUnicode:string] ;
#endif
    
    NSError *error = nil;
    self.responseModel = [[self.modelClass alloc] initWithData:recvData error:&error] ;
    if (error) {
        _dataParseError = [error copy];
    }
}




- (void) requestErrored:(CRequestCommand*)requestCommand
{
    CRequestJSONModelBase* responseModel = (CRequestJSONModelBase*)self.responseModel;
    if ( self.failure) {
        self.failure(-1, responseModel.msg,self,_dataParseError);
        self.success = nil;
        self.failure = nil;
        return;
    }

    if (self.jsonDelegate && [self.jsonDelegate respondsToSelector:@selector(requestErrored:)])
    {
        [self.jsonDelegate performSelector:@selector(requestErrored:) withObject:self];
    }
}

- (void) requestComplete:(CRequestCommand*)requestCommand
{
#ifdef DEBUG_PROFILE
    Warning(@"request Result == %@",self.originalData);
#endif
    CRequestJSONModelBase* responseModel = (CRequestJSONModelBase*)self.responseModel;

    //Block
    if (self.success || self.failure) {
        if (responseModel && [responseModel isKindOfClass:self.modelClass] && [responseModel.code isEqualToString:@"0"] && _dataParseError == nil) {
            //执行成功的Block
            if (self.success) {
                self.success(0,responseModel.msg, self);
            }
        }
        else
        {
            //执行失败的Block

            if (self.failure) {
                NSInteger code = -1;
                @try {
                    code = [responseModel.code integerValue];
                } @catch (NSException *exception) {
                    
                }
                self.failure(code, responseModel.msg,self,_dataParseError);
            }

        }
        self.success = nil;
        self.failure = nil;
        return;
        
    }
    if (self.responseModel && [responseModel.code isEqualToString:@"0"]) {
        if (self.jsonDelegate && [self.jsonDelegate respondsToSelector:@selector(requestComplete:)])
        {
            [self.jsonDelegate performSelector:@selector(requestComplete:) withObject:self];
        }
    }
    else{
        [self requestErrored:self];

    }

}

- (void)stopRequest
{
    [super stopRequest];
    self.success = nil;
    self.failure = nil;
}
@end
