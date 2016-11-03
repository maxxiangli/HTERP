//
//  CURLLoaderProxy.m
//  IOSLIB
//
//  Created by wang suning on 11-3-18.
//  Copyright 2011 tencent. All rights reserved.
//

#import "CURLLoaderProxy.h"


@implementation CURLLoaderProxy
@synthesize urlDataLoader = _urlDataLoader;
@synthesize url = _url;
@synthesize postData = _postData;
@synthesize postMultiData = _postMultiData;
@synthesize headerFields = _headerFields;

- (id)init
{
    if ((self = [super init])) 
	{
		self.urlDataLoader = nil;
		self.url = nil;
		self.postData = nil;
		self.postMultiData = nil;
		self.headerFields = nil;
		self.delegate = nil;
        _timeOutSeconds= 30;//默认30S

		_isLoading = NO;
    }
    return self;
}

- (void) urlDataLoaderGetted:(CURLDataLoader*)dataLoader
{
	if (self.url == nil) 
	{
		[[CURLLoaderCache sharedLoaderCache] releaseLoader:dataLoader];
		return;
	}
	self.urlDataLoader = dataLoader;
	self.urlDataLoader.delegate = self;
    [self.urlDataLoader setTimeOutSeconds:_timeOutSeconds];
    if([self.delegate respondsToSelector:@selector(urlDataLoadStartConnection:)])
    {
        //此时才真正开始发起连接
        [self.delegate urlDataLoadStartConnection:dataLoader];
    }
    
	if (self.postMultiData != nil && self.headerFields != nil)
	{
		[self.urlDataLoader loadMultiDataStart:self.url postData:self.postMultiData header:self.headerFields];
	}
	if (self.postMultiData != nil && self.headerFields == nil)
	{
		[self.urlDataLoader loadMultiDataStart:self.url postData:self.postMultiData header:nil];
	}
	else if (self.postData != nil && self.headerFields != nil)
	{
		[self.urlDataLoader loadDataStart:self.url postData:self.postData header:self.headerFields];
	}
	else if (self.postData != nil)
	{
		[self.urlDataLoader loadDataStart:self.url postData:self.postData];
	}
	else if (self.headerFields != nil)
	{
		[self.urlDataLoader loadDataStart:self.url header:self.headerFields];
	}
	else 
	{
		[self.urlDataLoader loadDataStart:self.url];
	}
}

- (void) urlDataLoadProgress:(CURLDataLoader*)loader progress:(float)progress
{
	if ([self.delegate respondsToSelector:@selector(urlDataLoadProgress:progress:)])
	{
		[self.delegate urlDataLoadProgress:loader progress:progress];
	}
}

- (void) urlDataLoadRecvHeader:(CURLDataLoader *)loader header:(NSDictionary *)header
{
	if ([self.delegate respondsToSelector:@selector(urlDataLoadRecvHeader:header:)])
	{
		[self.delegate urlDataLoadRecvHeader:loader header:header];
	}
}

- (BOOL) urlDataLoadAuthentication:(CURLDataLoader*)loader trustServer:(NSString*)host
{
	BOOL ret = NO;
	if ([self.delegate respondsToSelector:@selector(urlDataLoadAuthentication:trustServer:)])
	{
		ret = [self.delegate urlDataLoadAuthentication:loader trustServer:host];
	}
	return ret;
}

- (void) urlDataLoadComplete:(CURLDataLoader*)loader
{
	NSAssert(self.urlDataLoader == loader, @"loader必须相同");
	
	//由于有可能在urlDataLoadComplete中调用cancelLoadData，导致self.urlDataLoader为nil，所以加上下面的限制
	if (self.urlDataLoader != nil)
	{
		self.urlDataLoader.delegate = nil;
		self.urlDataLoader = nil;
	}
	_isLoading = NO;
	
	if ([self.delegate respondsToSelector:@selector(urlDataLoadComplete:)])
	{
		[self.delegate urlDataLoadComplete:loader];
	}
	[[CURLLoaderCache sharedLoaderCache] releaseLoader:loader];

//	//由于有可能在urlDataLoadComplete中调用cancelLoadData，导致self.urlDataLoader为nil，所以加上下面的限制
//	if (self.urlDataLoader != nil)
//	{
//		self.urlDataLoader.delegate = nil;
//		[[CURLLoaderCache sharedLoaderCache] releaseLoader:self.urlDataLoader];
//		self.urlDataLoader = nil;
//	}
//	_isLoading = NO;
}

- (void) urlDataLoadError:(CURLDataLoader*)loader errorCode:(TUrlDataLoadErrorCode)errorCode
{
	NSAssert(self.urlDataLoader == loader, @"loader必须相同");
	
	//由于有可能在urlDataLoadError中调用cancelLoadData，导致self.urlDataLoader为nil，所以加上下面的限制
	if (self.urlDataLoader != nil)
	{
		self.urlDataLoader.delegate = nil;
		self.urlDataLoader = nil;
	}
	_isLoading = NO;
	
	if ([self.delegate respondsToSelector:@selector(urlDataLoadError:errorCode:)])
	{
		[self.delegate urlDataLoadError:loader errorCode:errorCode];
	}
	[[CURLLoaderCache sharedLoaderCache] releaseLoader:loader];

//	//由于有可能在urlDataLoadError中调用cancelLoadData，导致self.urlDataLoader为nil，所以加上下面的限制
//	if (self.urlDataLoader != nil)
//	{
//		self.urlDataLoader.delegate = nil;
//		[[CURLLoaderCache sharedLoaderCache] releaseLoader:self.urlDataLoader];
//		self.urlDataLoader = nil;
//	}
//	_isLoading = NO;
}

- (void) loadMultiDataStart:(NSString*)url postData:(NSDictionary *)data header:(NSDictionary *)headerfield
{
	if (url == nil) return;
	if ([self isLoading]) return;
	self.url = url;
	self.postData = nil;
	self.postMultiData = data;
	self.headerFields = headerfield;
	_isLoading = YES;
	
	[[CURLLoaderCache sharedLoaderCache] newLoaderAsync:self];
}

- (void) loadDataStart:(NSString*)url postData:(NSData *)data
{
	if (url == nil) return;
	if ([self isLoading]) return;
	self.url = url;
	self.postData = data;
	self.postMultiData = nil;
	self.headerFields = nil;
	_isLoading = YES;
	
	[[CURLLoaderCache sharedLoaderCache] newLoaderAsync:self];
}

- (void) loadDataStart:(NSString*)url postData:(NSData *)data header:(NSDictionary *)headerfield
{
	if (url == nil) return;
	if ([self isLoading]) return;
	self.url = url;
	self.postData = data;
	self.postMultiData = nil;
	self.headerFields = headerfield;
	_isLoading = YES;
	
	[[CURLLoaderCache sharedLoaderCache] newLoaderAsync:self];
}

- (void) loadDataStart:(NSString*)url header:(NSDictionary *)headerfield
{
	if (url == nil) return;
	if ([self isLoading]) return;
	self.url = url;
	self.postData = nil;
	self.postMultiData = nil;
	self.headerFields = headerfield;
	_isLoading = YES;
	
	[[CURLLoaderCache sharedLoaderCache] newLoaderAsync:self];
}

- (void) loadDataStart:(NSString*)url
{
	if (url == nil) return;
	if ([self isLoading]) return;
	self.url = url;
	self.postData = nil;
	self.postMultiData = nil;
	self.headerFields = nil;
	_isLoading = YES;
	
	[[CURLLoaderCache sharedLoaderCache] newLoaderAsync:self];
}

- (void) cancelLoadData
{
	if (self.urlDataLoader != nil)
	{
		[self.urlDataLoader cancelLoadData];
		self.urlDataLoader.delegate = nil;
		[[CURLLoaderCache sharedLoaderCache] releaseLoader:self.urlDataLoader];
	}
	
	self.urlDataLoader = nil;
	self.url = nil;
	self.postData = nil;
	self.postMultiData = nil;
	self.headerFields = nil;
	_isLoading = NO;
}

- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds
{
    _timeOutSeconds = timeOutSeconds;
}

- (BOOL) isLoading
{
	return self.urlDataLoader != nil || _isLoading;
}

- (void)dealloc
{
	[self cancelLoadData];
	self.delegate = nil;

	
}

@end
