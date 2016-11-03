//
//  CURLLoaderProxy.h
//  IOSLIB
//
//  Created by wang suning on 11-3-18.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CURLLoaderCache.h"


//为适配CURLLoaderCache而做的Proxy，用法和直接使用CURLDataLoader相同
@interface CURLLoaderProxy : NSObject<CURLDLoaderCacheDelegate>
{
	CURLDataLoader* _urlDataLoader;
	BOOL _isLoading;
	NSString* _url;
	NSData* _postData;
	NSDictionary* _postMultiData;
	NSDictionary* _headerFields;
    NSUInteger _timeOutSeconds;//默认30S

}

@property (nonatomic,retain) CURLDataLoader* urlDataLoader;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,retain) NSData* postData;
@property (nonatomic,retain) NSDictionary* postMultiData;
@property (nonatomic,retain) NSDictionary* headerFields;
@property (nonatomic,weak) id<CURLDataLoaderDelegate> delegate;

- (void) loadMultiDataStart:(NSString*)url postData:(NSDictionary *)data header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url postData:(NSData *)data;
- (void) loadDataStart:(NSString*)url postData:(NSData *)data header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url header:(NSDictionary *)headerfield;
- (void) loadDataStart:(NSString*)url;

- (BOOL) isLoading;
- (void) cancelLoadData;
- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds;//默认30S
@end
