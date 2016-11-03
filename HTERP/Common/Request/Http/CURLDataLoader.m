//
//  CURLDataLoader.m
//  IOSLIB
//
//  Created by 苏宁 on 10-10-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CURLDataLoader.h"
#import <CFNetwork/CFNetwork.h>
#import "CMD5Util.h"
//#import "CFileHandle.h"

#define kHTTPBoundary @"---------IOSLIB-MUTABLEDATA---------"
#define kTIMEOUTVALUE 30.0f

@interface CAsyncObject : NSObject
{
	id			data_1;
	id			data_2;
}
@property	(readwrite,retain)	id			data1;
@property	(readwrite,retain)	id			data2;
@end

@implementation CAsyncObject
@synthesize data1 = data_1;
@synthesize data2 = data_2;
- (void) dealloc
{
	
	
	
}
@end

@interface CURLDataLoader ()

- (void) startTimeoutTimer;
- (void) stopTimeoutTimer;

@end


@implementation CURLDataLoader
@synthesize responseHeader = _responseHeader;
@synthesize urlData = _urlData;
@synthesize urlStr = _urlStr;
@synthesize urlConnection = _urlConnection;

- (id)init
{
    if ((self = [super init])) 
	{
		self.responseHeader = nil;
		self.urlStr = nil;
		self.urlData = nil;
		self.urlConnection = nil;
		self.delegate = nil;
        _timeOutSeconds = kTIMEOUTVALUE;
		_contentLength = 0.0f;
    }
    return self;
}

+ (CURLDataLoader*) urlDataLoader
{
	return [[CURLDataLoader alloc] init] ;
}

- (void) startTimeoutTimer
{
	[self stopTimeoutTimer];
	[self performSelector:@selector(timeoutCallback:) withObject:nil afterDelay:_timeOutSeconds];
}

- (void) stopTimeoutTimer
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutCallback:) object:nil];
}

- (void) timeoutCallback:(id)param
{
	if ([self isLoading])
	{
        //放在delegate回调后面调用，因为该函数会将urlStr属性置空
        //[self cancelLoadData];
		if ([self.delegate respondsToSelector:@selector(urlDataLoadError:errorCode:)])
		{
			[self.delegate urlDataLoadError:self errorCode:eURLErrorTimeout];
		}
        [self cancelLoadData];
	}
}

- (void) loadMultiDataStart:(NSString*)url postData:(NSDictionary *)data header:(NSDictionary *)headerfield
{
    NSAssert(url != nil, @"url不能为nil");
    NSAssert(self.delegate != nil, @"必须先指定代理");
    if (self.urlConnection != nil) return;
    if (self.urlStr != nil) return;
    
    NSMutableDictionary *postHeader = [headerfield mutableCopy] ;
    if (postHeader == nil)
    {
        postHeader = [NSMutableDictionary dictionary];
    }
    
    if ([headerfield objectForKey:@"Content-type"] == nil || [[headerfield objectForKey:@"Content-type"] isEqualToString:@""])
    {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kHTTPBoundary];
        [postHeader setObject:contentType forKey:@"Content-type"];
    }
  
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray* allKeys = [data allKeys];
    for (int i = 0; i < [allKeys count]; i++)
    {
        NSString *key = [allKeys objectAtIndex:i];
        
        id value = [data valueForKey:key];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSConstantString class]])
        {
            XLOG(@"value: %@", value);
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if ([value isKindOfClass:[NSData class]])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, @"image.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: image/pjpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:value];
        }
        if (i + 1 < [allKeys count])
        {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self loadDataStart:url postData:body header:postHeader];
    //XLOGF(@"url=%@, body=%@, header=%@", url, body, postHeader);
}

- (void) loadDataStart:(NSString*)url postData:(NSData *)data header:(NSDictionary *)headerfield
{
	NSAssert(url != nil, @"url不能为nil");
	NSAssert(self.delegate != nil, @"必须先指定代理");
	if (self.urlConnection != nil) return;
	if (self.urlStr != nil) return;
	
	XLOG(@"loadDataStart URL: %@", url);
	XLOGDATASTR(data);
	NSMutableURLRequest *urlPost = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:600];
	if (headerfield != nil) 
	{
		[urlPost setAllHTTPHeaderFields:headerfield];
	}
	[urlPost setHTTPMethod:@"POST"];
	[urlPost setHTTPBody:data];
    
	self.urlConnection = [NSURLConnection connectionWithRequest:urlPost delegate:self];
	self.urlStr = url;
	_httpMethod = @"POST";

	NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
	
	[self startTimeoutTimer];
	//RECORED_REQUEST(url, data, headerfield);
}

- (void) loadDataStart:(NSString*)url postData:(NSData *)data
{
	NSAssert(url != nil, @"url不能为nil");
	NSAssert(self.delegate != nil, @"必须先指定代理");
	if (self.urlConnection != nil) return;
	if (self.urlStr != nil) return;
	
	XLOG(@"loadDataStart URL: %@", url);
	NSMutableURLRequest *urlPost = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:55];
	[urlPost setHTTPMethod:@"POST"];
	[urlPost setHTTPBody:data];

	self.urlConnection = [NSURLConnection connectionWithRequest:urlPost delegate:self];
	self.urlStr = url;
	_httpMethod = @"POST";

	NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
	
	[self startTimeoutTimer];
	//RECORED_REQUEST(url, data, nil);
}

- (void) loadDataStartKeepAlive:(NSString*)url postData:(NSData *)data
{
	NSDictionary* keepAliveHeader = [NSDictionary dictionaryWithObject:@"Keep-Alive" forKey:@"Connection"];
	[self loadDataStart:url postData:data header:keepAliveHeader];
}

- (void) loadDataStart:(NSString*)url header:(NSDictionary *)headerfield
{
	NSAssert(url != nil, @"url不能为nil");
	NSAssert(self.delegate != nil, @"必须先指定代理");
	if (self.urlConnection != nil) return;
	if (self.urlStr != nil) return;
	
	XLOG(@"loadDataStart URL: %@", url);
    XLOG(@"loadDataStart HTTP headers: %@", headerfield);
	self.urlStr = url;
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:55];
	if (headerfield != nil) [urlRequest setAllHTTPHeaderFields:headerfield];
	self.urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
	_httpMethod = @"GET";
	
	[self startTimeoutTimer];
	//RECORED_REQUEST(url, nil, headerfield);
}

- (void) loadDataStart:(NSString*)url
{
	NSAssert(url != nil, @"url不能为nil");
	NSAssert(self.delegate != nil, @"必须先指定代理");
	if (self.urlConnection != nil) return;
	if (self.urlStr != nil) return;
	
	XLOG(@"loadDataStart URL: %@", url);
	self.urlStr = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:600];
	self.urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
	_httpMethod = @"GET";
	
	[self startTimeoutTimer];
	//RECORED_REQUEST(url, nil, nil);
}

- (void) cancelLoadData
{
	_contentLength = 0.0f;
	_httpMethod = nil;
	self.responseHeader = nil;
	self.urlData = nil;
	[self stopTimeoutTimer];
	
	if (self.urlConnection != nil)
	{
		[self.urlConnection cancel];
		self.urlConnection = nil;
	}
	if (self.urlStr != nil)
	{
		//RECORED_CANCELED(self.urlStr);
	}
	self.urlStr = nil;
}

- (BOOL) isLoading
{
	return self.urlStr != nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if (self.urlConnection == nil) return;
	self.urlData = [NSMutableData data];
	[self startTimeoutTimer];
/*
	XLOGH(@"URL: %@", [response URL]);
	NSHTTPURLResponse* tResponse = (NSHTTPURLResponse*) response;
	NSDictionary* tFields = [tResponse allHeaderFields];
	for (NSString* tKey in [tFields allKeys])
	{
		XLOGH(@"Key: %@", tKey);
		XLOGH(@"Value: %@", [tFields valueForKey:tKey]);
	}
	XLOGH(@"expectedContentLength:%lld", [response expectedContentLength]);
*/
	NSHTTPURLResponse* tResponse = (NSHTTPURLResponse*) response;
	NSDictionary* header = [tResponse allHeaderFields];
    if (header != nil)
    {
        NSMutableDictionary* h = [NSMutableDictionary dictionaryWithDictionary:header];
        [h setValue:[NSString stringWithFormat:@"%ld", (long)[tResponse statusCode]] forKey:@"kStatusCode"];
        header = h;
    }
    
	//RECORED_RESPONSE_HEADER(self.urlStr, header);
	self.responseHeader = header;
	if ([self.delegate respondsToSelector:@selector(urlDataLoadRecvHeader:header:)])
	{
		[self.delegate urlDataLoadRecvHeader:self header:self.responseHeader];
	}
	if ([self.delegate respondsToSelector:@selector(urlDataLoadProgress:progress:)])
	{
		XLOG(@"URL: %@", [response URL]);
		NSString* tContentLengthValue = [self.responseHeader valueForKey:@"Content-Length"];
		if (tContentLengthValue != nil && [tContentLengthValue length] > 0)
		{
			XLOG(@"convert content-length[%@] to float", tContentLengthValue);
			_contentLength = [tContentLengthValue floatValue];
		}
		[self.delegate urlDataLoadProgress:self progress:0.0f];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (self.urlConnection == nil) return;
	[self.urlData appendData:data];
	[self startTimeoutTimer];
	
	if ([self.delegate respondsToSelector:@selector(urlDataLoadProgress:progress:)])
	{
		float progress = 0.0f;
		if (_contentLength > 0.0f)
		{
			progress = [self.urlData length] * 1.0f / _contentLength;
		}
		[self.delegate urlDataLoadProgress:self progress:progress];
	}
}
/*
- (void) printProtectionSpace:(NSURLProtectionSpace*)protectionSpace
{
	NSLog(@"printProtectionSpace ============Start");
	NSLog(@"authenticationMethod: %@", protectionSpace.authenticationMethod);
	NSLog(@"realm: %@", [protectionSpace realm]);
	
	NSLog(@"receivesCredentialSecurely: %@", [protectionSpace receivesCredentialSecurely] ? @"true" : @"false");
	NSLog(@"isProxy: %@", [protectionSpace isProxy] ? @"true" : @"false");
	NSLog(@"host: %@", [protectionSpace host]);
	NSLog(@"port: %d", [protectionSpace port]);
	NSLog(@"proxyType: %@", [protectionSpace proxyType]);
	NSLog(@"protocol: %@", [protectionSpace protocol]);
	
	NSLog(@"distinguishedNames: %@", [protectionSpace distinguishedNames]);
	NSLog(@"printProtectionSpace ============End");
}

- (void) printCredential:(NSURLCredential *)proposedCredential
{
	NSLog(@"printCredential ============Start");
	NSLog(@"persistence: %d", [proposedCredential persistence]);
	NSLog(@"user: %@", [proposedCredential user]);
	NSLog(@"password: %@", [proposedCredential password]);
	NSLog(@"certificates: %@", [proposedCredential certificates]);
	NSLog(@"printCredential ============End");
}
*/

- (void) trustChallenge:(NSURLAuthenticationChallenge *)challenge
{
  //	[self printCredential:[challenge proposedCredential]];
  //	[self printProtectionSpace:[challenge protectionSpace]];
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		if (![self.delegate respondsToSelector:@selector(urlDataLoadAuthentication:trustServer:)] ||
        [self.delegate urlDataLoadAuthentication:self trustServer:challenge.protectionSpace.host])
		{
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
		}
	}
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
//	[self printProtectionSpace:protectionSpace];
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  [self trustChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	// do nothing now
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
	return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	[self trustChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (self.urlConnection == nil) return;
	self.urlConnection = nil;
	[self stopTimeoutTimer];
	
	XLOG(@"connection error:%@", error);
	TUrlDataLoadErrorCode errorCode = eURLErrorUnknown;
//    if ([error code] == kCFURLErrorNotConnectedToInternet)
//	{
//        errorCode = eURLErrorNotConnectedToInternet;
//    }
//	else if ([error code] <= kCFURLErrorCannotConnectToHost && [error code] >= kCFURLErrorNotConnectedToInternet)
//	{
//		errorCode = eURLErrorCannotConnectToHost;
//	}
//	RECORED_ERRORED(self.urlStr, [error code]);
	
    if(error)
    {
        errorCode = (TUrlDataLoadErrorCode)[error code];
    }
	if ([self isLoading] && [self.delegate respondsToSelector:@selector(urlDataLoadError:errorCode:)])
	{
		[self.delegate urlDataLoadError:self errorCode:errorCode];
	}
	self.responseHeader = nil;
	self.urlData = nil;
	self.urlStr = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	if (self.urlConnection == nil) return;
	self.urlConnection = nil;
	[self stopTimeoutTimer];
	//RECORED_COMPLETE(self.urlStr, self.urlData);
	
	if ([self isLoading])
	{
		if ([self.delegate respondsToSelector:@selector(urlDataLoadComplete:)])
		{
			[self.delegate urlDataLoadComplete:self];
/*			if ([self.urlData length] > 0)
			{
				[self.delegate urlDataLoadComplete:self];
			}
			else 
			{
				[self.delegate urlDataLoadError:self errorCode:eURLErrorReceiveDataZeroLength];
			}
*/
			self.responseHeader = nil;
			self.urlData = nil;
			self.urlStr = nil;
		}
	}
	else 
	{
		self.responseHeader = nil;
		self.urlData = nil;
	}
}

- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds
{
    _timeOutSeconds = timeOutSeconds;
}

- (void)dealloc
{
	[self cancelLoadData];
	self.urlConnection = nil;
	self.responseHeader = nil;
	self.urlStr = nil;
	self.urlData = nil;
	self.delegate = nil;

	
}
@end
