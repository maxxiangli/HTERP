//
//  CURLDataLoader.h
//  IOSLIB
//
//  Created by 苏宁 on 10-10-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
	eURLErrorNone = 0,
	eURLErrorReceiveDataZeroLength = 3,
	eURLErrorTimeout = 4,
	eURLErrorUnknown = 5
};
typedef CFNetworkErrors TUrlDataLoadErrorCode;

@class CURLDataLoader;
@protocol CURLDataLoaderDelegate<NSObject>

@optional
//!!!!!!注意，以下所有调用在子线程完成，如果需要刷新UI，请在主线程进行，否则会出现异常
- (void) urlDataLoadStartConnection:(CURLDataLoader*)loader;
- (void) urlDataLoadRecvHeader:(CURLDataLoader*)loader header:(NSDictionary*)header;
- (void) urlDataLoadProgress:(CURLDataLoader*)loader progress:(float)progress;
- (void) urlDataLoadComplete:(CURLDataLoader*)loader;
- (void) urlDataLoadError:(CURLDataLoader*)loader errorCode:(TUrlDataLoadErrorCode)errorCode;
- (BOOL) urlDataLoadAuthentication:(CURLDataLoader*)loader trustServer:(NSString*)host;

@end

@interface CURLDataLoader : NSObject
{
	NSString* _urlStr;
	NSURLConnection* _urlConnection;
	NSMutableData* _urlData;
    NSUInteger _timeOutSeconds;//默认30S
	float _contentLength;
	NSString *_httpMethod;

}

@property (copy) NSString* urlStr;
@property (retain) NSDictionary* responseHeader;
@property (retain) NSMutableData* urlData;
@property (retain) NSURLConnection* urlConnection;
@property (weak) id<CURLDataLoaderDelegate> delegate;

+ (CURLDataLoader*) urlDataLoader;

- (void) loadMultiDataStart:(NSString*)url postData:(NSDictionary *)data header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url postData:(NSData *)data;
- (void) loadDataStart:(NSString*)url postData:(NSData *)data header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url;
- (void) loadDataStartKeepAlive:(NSString*)url postData:(NSData *)data;

- (void) cancelLoadData;
- (BOOL) isLoading;
- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds;//默认30S

@end
