//
//  CRequestCommand.h
//  QQStock
//
//  Created by suning wang on 11-12-5.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CURLLoaderProxy.h"

#define kHttpRequestErrorNotification @"HTTPREQUESTERRORNOTIFICATION"

@protocol CRequestCommandDelegate;
@interface CRequestCommand : NSObject <CURLDataLoaderDelegate>
{
}
/****
 目前以下数据不需要记录错误日志
CRemoteImageRequest
CSmartBoxUpdateRequest
CPDFFileRequest
CStockNoticeContentRequest
CStockNewsContentRequest
CNewsContentRequest
****/
@property (nonatomic,assign) BOOL allowMergeHostByRemoteControl;    //是否允许远程控制更改host，默认允许；该功能允许后台对app进行域名替换的控制
@property (nonatomic,assign) BOOL enableLogResponseForDetectError;   //是否将返回书就打入log，以备定位错误；默认打开；该功能需要配合CStockLog使用
@property (strong) NSString* url;
@property (nonatomic,assign) TUrlDataLoadErrorCode httpErrorCode;
@property (nonatomic,weak) id<CRequestCommandDelegate> delegate;
@property (nonatomic,copy) NSString* contentCharset;

- (id) initWithDelegate:(id<CRequestCommandDelegate>)delegate;

- (void) startRequest:(NSString*)url postData:(NSDictionary*)postData;
- (void) startRequest:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header;
- (void) startRequestWithStringBody:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header;
- (void) startRequestWithStringData:(NSString*)url postData:(NSString*)postData header:(NSDictionary*)header;
- (void) startRequestWithStringData:(NSString*)url postDataJson:(NSDictionary *)dict header:(NSDictionary *)header;
- (BOOL) isRequesting;
- (void) stopRequest;

//券商交易统一的请求
- (void) tradeRequest:(NSString*)url postData:(NSDictionary*)postData header:(NSDictionary*)header;

//在子类实现
- (void) parserDataInThread:(NSData*)recvData;
//默认实现是调用delegate的requestComplete方法
- (void) requestCompleteInMainThread;
- (void) requestErrorOccorredInMainThread;

- (NSString *)getStringFromData:(NSData *)data; //返回的数据指针已经retain为1,需要强制release

- (NSString *)getRequestUrlForTest;

- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds;//默认30S
@end


@protocol CRequestCommandDelegate <NSObject>

@optional
- (void) requestErrored:(CRequestCommand*)requestCommand;
@required
- (void) requestComplete:(CRequestCommand*)requestCommand;

@end

@protocol CRequestDelegate <NSObject>
@optional
- (void) requestCompleteWithParams:(NSDictionary*)params;
- (void) requestErroredWithParams:(NSDictionary*)params;
- (void) requestCompleteWithParams:(NSDictionary*)params sender:(id)sender;
- (void) requestErroredWithParams:(NSDictionary*)params sender:(id)sender;

@optional
- (void) timingTaskWillTicked:(NSDictionary*)params;

@end
