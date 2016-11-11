//
//  CRequestCommand.m
//  QQStock
//
//  Created by suning wang on 11-12-5.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import "CRequestCommand.h"
//#import "CRequestDomainCacheManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//add by maxxiangli for boss reporter on 20130514
//#import "CMIGReporter.h"
#import "HttpDnsManager.h"
#import "CConfiguration.h"

#define kBossDataDicEventID         @"itil_cgi_access_quality"
#define kBossDataDicKeyResult       @"result"
#define kBossDataDicKeyTime         @"timeEplase"
#define kBossDataDicKeyHeader       @"receiveHeader"
#define kBossDataDicKeyUrl          @"url"

#define kBossReportRate             5
static int requestNum = 0;//add by maxxiangli for boss reporter on 20130709 for 采样上报率

@interface CRequestCommand ()
{
    CRequestCommand* me;//自己持有自己
}

@property (retain) CURLLoaderProxy* urlDataLoaderProxy;
@property (retain) NSDictionary* postData;
@property (retain) NSData* stringPostData;
@property (retain) NSDictionary* header;
@property (assign) BOOL start;
@property (retain) CStopWatch* stopWatch;

@property (assign) double timeSlot1;
@property (assign) double timeSlot2;

@property (assign) BOOL isReleased;

@property (retain) NSDate *beginRequestTime;//add by maxxiangli for boss reporter on 20130514
@property (retain) NSDate *receiveHeaderTime;
@property (retain) NSDate *completeTime;
@property (retain) NSDictionary *receiveHeaderData;
//@property (retain) WDKAppMonitorStat *monitorStat;//add by maxxiangli for boss reporter on 20130514
@property (assign) BOOL isNeedReport;//add by maxxiangli for boss reporter on 20130709 for 是否上报

@property (retain) HttpDnsRecord *httpDnsRecord; //add by abelchen，替换的httpDns记录

- (void) safeRetain;
- (void) safeRelease;

@end

@implementation CRequestCommand
@synthesize urlDataLoaderProxy = _urlDataLoaderProxy;
@synthesize postData = _postData;
@synthesize stringPostData = _stringPostData;
@synthesize header = _header;
@synthesize url = _url;
@synthesize start = _start;
@synthesize httpErrorCode = _httpErrorCode;
@synthesize delegate = _delegate;
@synthesize stopWatch = _stopWatch;

@synthesize timeSlot1 = _timeSlot1;
@synthesize timeSlot2 = _timeSlot2;

@synthesize isReleased = _isReleased;
@synthesize contentCharset = _contentCharset;
@synthesize beginRequestTime = _beginRequestTime;
@synthesize isNeedReport = _isNeedReport;

- (id) init
{
	self = [super init];
	if (self)
	{
        self.allowMergeHostByRemoteControl = YES;
        self.enableLogResponseForDetectError = YES;
		self.urlDataLoaderProxy = [[CURLLoaderProxy alloc] init] ;
		self.urlDataLoaderProxy.delegate = self;
		self.postData = nil;
		self.stringPostData = nil;
		self.header = nil;
		self.url = nil;
		self.httpErrorCode = eURLErrorNone;
		self.start = NO;
		self.delegate = nil;
		self.isReleased = YES;
		self.contentCharset = nil;

//		self.stopWatch = [CStopWatch stopwatch];
	}
	return self;
}

- (id) initWithDelegate:(id<CRequestCommandDelegate>)delegate
{
	self = [self init];
	if (self)
	{
		self.delegate = delegate;
	}
	return self;
}

/**是否测试地址
 *
 */
- (BOOL)isTestUrl:(NSString *)urlStr
{
    unichar character = 0;
    
    //获取域名的第一个字母
    if ( [urlStr length] > [@"http://" length] )
    {
        character = [urlStr characterAtIndex:[@"http://" length]];
    }
    
    if ( character >= '0' && character <= '9' )
    {
//        NSAssert(NO, @"－－－－－正在使用测试地址－－－－－");
        return YES;
    }
    
    return NO;
}

- (void) startRequest:(NSString*)url postData:(NSDictionary*)postData
{
	[self startRequest:url postData:postData header:nil];
}

- (void) startRequest:(NSString*)inputUrl postData:(NSDictionary*)postData header:(NSDictionary*)header
{
	if ([self isRequesting]) return;

	self.start = YES;
    [self safeRetain];

	self.httpErrorCode = eURLErrorNone;
	self.url = inputUrl;
	self.postData = postData;
    
    //域名替换
    if(self.allowMergeHostByRemoteControl)
    {
        self.url = [self mergeHost:self.url];
    }
    
    //begin add by maxxiangli for 后台数据上报 on 20130514 (550是50只股票短行情url长度)
	if ( [self.url length] < 550 && ![self.url hasPrefix:@"https://qian.tenpay.com/app/api"])//理财通要校验md5，忽略这些参数
    {
        NSMutableString *newUrl = [NSMutableString stringWithString:self.url];

        if ( [self.url rangeOfString:@"?"].length > 0 )
        {
            [newUrl appendString:@"&"];
        }
        else if ( [self.url rangeOfString:@"&"].length > 0 )
        {
            [newUrl appendString:@"&"];
        }
        else
        {
            [newUrl appendString:@"?"];
        }
        
        if([newUrl rangeOfString:@"&_rndtime="].length <= 0 && [newUrl rangeOfString:@"?_rndtime="].length <= 0)
        {
            [newUrl appendFormat:@"_rndtime=%d&", (unsigned int)[[NSDate date] timeIntervalSince1970]];
        }
        
        [newUrl appendString:[[CConfiguration sharedConfiguration] getReportInfor]];
        
        self.url = newUrl;
    }
    //end add by maxxiangli for 后台数据上报 on 20130514 (550是50只股票短行情url长度)
    
	if (header == nil)
	{
		header = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"gzip,deflate", @"Accept-Encoding",
				  @"http://zixuanguapp.finance.qq.com", @"referer",
				  nil];
	}
	else 
	{
		NSMutableDictionary* muDict = [NSMutableDictionary dictionaryWithDictionary:header];
		[muDict setObject:@"gzip,deflate" forKey:@"Accept-Encoding"];
		[muDict setObject:@"http://zixuanguapp.finance.qq.com" forKey:@"referer"];
		header = muDict;
	}
	self.header = header;
	
//	[self.stopWatch startWatch];
	[[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(startRequestInThread) withObject:self];
//	辅助线程测试
//	[self startRequestInThread];
}


//交易不需要上报
- (void) tradeRequest:(NSString*)inputUrl postData:(NSDictionary*)postData header:(NSDictionary*)header
{
	if ([self isRequesting]) return;
	
	[self safeRetain];
	self.start = YES;
	self.httpErrorCode = eURLErrorNone;
	self.url = inputUrl;
	self.postData = postData;
    
    //域名替换
    if(self.allowMergeHostByRemoteControl)
    {
        self.url = [self mergeHost:self.url];
    }
    
	if (header == nil)
	{
		header = [NSDictionary dictionaryWithObject:@"gzip,deflate" forKey:@"Accept-Encoding"];
	}
	else
	{
		NSMutableDictionary* muDict = [NSMutableDictionary dictionaryWithDictionary:header];
		[muDict setObject:@"gzip,deflate" forKey:@"Accept-Encoding"];
		header = muDict;
	}
	self.header = header;


	[[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(startRequestInThread) withObject:self];
}

- (void) startRequestWithStringData:(NSString*)inputUrl postData:(NSString*)postData header:(NSDictionary*)header
{
    if ([self isRequesting]) return;
    
    [self safeRetain];
    self.start = YES;
    self.httpErrorCode = eURLErrorNone;
    self.url = inputUrl;
    
    //域名替换
    if(self.allowMergeHostByRemoteControl)
    {
        self.url = [self mergeHost:self.url];
    }
    
    if (postData) {
        self.stringPostData = [postData dataUsingEncoding:NSUTF8StringEncoding];
    }
    self.header = header;
    
    [[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(startRequestInThread) withObject:self];
}

- (void) startRequestWithStringData:(NSString*)url postDataJson:(NSDictionary *)dict header:(NSDictionary *)header
{
    [self startRequestWithStringData:url postData:[self formatParamsToJson:dict] header:header];
}

- (void) startRequestWithStringBody:(NSString*)inputUrl postData:(NSDictionary*)postData header:(NSDictionary*)header
{
	if ([self isRequesting]) return;
	
	[self safeRetain];
	self.start = YES;
	self.httpErrorCode = eURLErrorNone;
	self.url = inputUrl;
	
    //域名替换
    if(self.allowMergeHostByRemoteControl)
    {
        self.url = [self mergeHost:self.url];
    }
    
	if (postData) {
		NSMutableData *body = [NSMutableData data];
		for (NSString *key in [postData allKeys]) {
			id value = [postData valueForKey:key];
			if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSConstantString class]])
			{
				XLOG(@"value: %@", value);
                if([body length] > 0)
                {
                    [body appendData:[[NSString stringWithFormat:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
				[body appendData:[[NSString stringWithFormat:@"%@=",key] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			else if ([value isKindOfClass:[NSData class]])
			{
				[body appendData:value];
			}
		}
		self.stringPostData = [NSData dataWithData:body];
	}
	
	
    //begin add by maxxiangli for 后台数据上报 on 20130514 (550是50只股票短行情url长度)
    if ( [self.url length] < 550 )
    {
        NSMutableString *newUrl = [NSMutableString stringWithString:self.url];
		
        if ( [self.url rangeOfString:@"?"].length > 0 )
        {
            [newUrl appendString:@"&"];
        }
        else if ( [self.url rangeOfString:@"&"].length > 0 )
        {
            [newUrl appendString:@"&"];
        }
        else
        {
            [newUrl appendString:@"?"];
        }
        
        if([newUrl rangeOfString:@"&_rndtime="].length <= 0 && [newUrl rangeOfString:@"?_rndtime="].length <= 0)
        {
            [newUrl appendFormat:@"_rndtime=%d&", (unsigned int)[[NSDate date] timeIntervalSince1970]];
        }
        
        [newUrl appendString:[[CConfiguration sharedConfiguration] getReportInfor]];
        
        self.url = newUrl;
    }
    //end add by maxxiangli for 后台数据上报 on 20130514 (550是50只股票短行情url长度)
    
    if (header == nil)
    {
        header = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"gzip,deflate", @"Accept-Encoding",
                  @"http://zixuanguapp.finance.qq.com", @"referer",
                  nil];
    }
    else
    {
        NSMutableDictionary* muDict = [NSMutableDictionary dictionaryWithDictionary:header];
        [muDict setObject:@"gzip,deflate" forKey:@"Accept-Encoding"];
        [muDict setObject:@"http://zixuanguapp.finance.qq.com" forKey:@"referer"];
        header = muDict;
    }
	self.header = header;
	
	[[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(startRequestInThread) withObject:self];
	//	辅助线程测试
	//	[self startRequestInThread];
}

- (NSString *)mergeHost:(NSString *)srcUrl
{
    return srcUrl;
//    return [CDynamicControl mergeHostForUrl:srcUrl];
}

//参数格式化：字典转换为json字符串
- (NSString *)formatParamsToJson:(NSDictionary *)paramsDict
{
    NSMutableString *paramsStr = [[NSMutableString alloc] initWithString:@"{"] ;
    
    
    for (NSString *key in paramsDict)
    {
        NSString *itemParams = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,paramsDict[key]];
        [paramsStr appendString:itemParams];
        [paramsStr appendString:@","];
    }
    NSString *params = [NSString stringWithString:paramsStr];
    if (params.length > 1)
    {
        params = [params substringToIndex:params.length - 1];
    }
    
    params = [params stringByAppendingString:@"}"];
    
    return  params;
}

//是否为不需要dns处理的url
- (BOOL)isDNSExcetipnUrl:(NSString *)url
{
    if ( ![url isKindOfClass:[NSString class]] )
    {
        return YES;
    }
    
    if ( [url rangeOfString:@"appstock/support/dynamicRemote/comp"].length
        || [url rangeOfString:@"appstock/httpdns/domain/whitelist"].length
        )
    {
        return YES;
    }
    
    return NO;
}

- (void) startRequestInThread
{
//	[self.stopWatch lap:@"1、主线程切换到辅助线程时间"];
	if ([self.urlDataLoaderProxy isLoading]) return;
	
	[self.stopWatch startWatch];
    
    NSString *url = self.url;
    // HttpDns替换host
    if(!self.httpDnsRecord && [HttpDnsManager sharedManager].enabled){ // 第一次请求才替换host，而重试使用原来的host
        if ( ![self isDNSExcetipnUrl:self.url] )
        {
            NSURLComponents *nsurl = [NSURLComponents componentsWithString: self.url];
            // 只替换http请求
            if(nsurl && [nsurl.scheme isEqualToString: @"http"]){
                HttpDnsRecord *record = [[HttpDnsManager sharedManager] recordForHost: nsurl.host];
                if(record && record.address){
                    self.httpDnsRecord = record;
                    if(self.header){
                        NSMutableDictionary *newHeader = [NSMutableDictionary dictionaryWithDictionary:self.header];
                        [newHeader setObject:nsurl.host forKey:@"host"];
                        self.header = newHeader;
                    }else{
                        self.header = @{@"host":nsurl.host};
                    }
                    nsurl.host = record.address;
                    url = nsurl.URL.absoluteString;
                    
                    DNSLog(@"replace url: [%@]", url);
                }else{
                    DNSLog(@"use origin url: [%@]", url);
                }
            }
        }
    }else{
        // 如果不使用httpdns就把httpDnsRecord置空，免得复用请求时出错
        self.httpDnsRecord = nil;
    }
    
	if (self.postData != nil)
	{
		[self.urlDataLoaderProxy loadMultiDataStart:url postData:self.postData header:self.header];
	}
	else if (self.stringPostData != nil)
	{
		[self.urlDataLoaderProxy loadDataStart:url postData:self.stringPostData header:self.header];
	}
	else
	{
		[self.urlDataLoaderProxy loadDataStart:url header:self.header];
	}
    
    //add by maxxiangli for 纪录请求的开始时间 on 20130514
    requestNum++;
    if ( requestNum >= kBossReportRate )
    {
        self.isNeedReport = YES;
        requestNum = 0;
    }
    else
    {
        self.isNeedReport = NO;
    }
    
    //测试地址不上报
    if ( self.isNeedReport && [self isTestUrl:self.url] )
    {
        self.isNeedReport = NO;
    }
    if ( self.isNeedReport )
    {
        //仅仅为了初始化，避免网络失败导致没有时间
        NSDate *beginTime = [NSDate date];
        self.beginRequestTime = beginTime;
        self.receiveHeaderTime = beginTime;
    }
}

- (BOOL) isRequesting
{
	return self.start || [self.urlDataLoaderProxy isLoading];
}

- (void) stopRequest
{
	if (self.start)
	{
		self.start = NO;
//		[[CWorkedThread sharedWorkedThread] performTargetSync:self selector:@selector(stopRequestInThread) withObject:self];
		[[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(stopRequestInThread) withObject:self];
	}
}

- (void) stopCompleteInMainThread
{
	[self safeRelease];
}

- (void) stopRequestInThread
{
	[self.urlDataLoaderProxy cancelLoadData];
	[self performSelectorOnMainThread:@selector(stopCompleteInMainThread) withObject:nil waitUntilDone:NO];
}

- (void)setTimeOutSeconds:(NSUInteger)timeOutSeconds
{
    if (self.urlDataLoaderProxy) {
        [self.urlDataLoaderProxy setTimeOutSeconds:timeOutSeconds];
    }
}
- (void) parserDataInThread:(NSData*)recvData
{
}
/*
- (void) urlDataLoadRecvHeader:(CURLDataLoader *)loader header:(NSDictionary *)header
{
	self.timeSlot1 = [self.stopWatch getRunningTime];
}
*/


- (void) __requestCompleteInMainThread
{
//	[self.stopWatch lap:@"4、从线程切换回主线程时间"];
//	[self.stopWatch startWatch];
	if (self.start)
	{
		self.start = NO;
		[self requestCompleteInMainThread];
	}
	[self safeRelease];
//	[self.stopWatch lap:@"5、主线程处理数据时间"];
}

- (void) requestCompleteInMainThread
{
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestComplete:)])
	{
		[self.delegate requestComplete:self];
	}
}

#pragma mark - CURLDataLoaderDelegate
- (void) urlDataLoadStartConnection:(CURLDataLoader *)loader
{
    //此时才真正开始发起连接
    if ( self.isNeedReport )
    {
        NSDate *beginTime = [NSDate date];
        self.beginRequestTime = beginTime;
        self.receiveHeaderTime = beginTime;
    }
}

- (void) urlDataLoadRecvHeader:(CURLDataLoader *)loader header:(NSDictionary *)header
{
    self.receiveHeaderData = header;
    self.receiveHeaderTime = [NSDate date];
    
//    if ( [[header valueForKey:@"kStatusCode"] isKindOfClass:[NSString class]])
//    {
//        self.monitorStat.returnCode = [[header valueForKey:@"kStatusCode"] intValue];
//    }
    
	self.contentCharset = nil;
	NSString* contentType = [header valueForKey:@"Content-Type"];
	if (contentType != nil && [contentType length] > 0)
	{
		contentType = [contentType uppercaseString];
		NSRange r = [contentType rangeOfString:@"CHARSET"];
		if (r.length > 0)
		{
			int s = 0;
			int i = (int)NSMaxRange(r);
			int l = (int)[contentType length];
			int start = -1;
			int end = -1;
			while (i < l)
			{
				unichar c = [contentType characterAtIndex:i];
				if (!isspace(c))
				{
					if (c == ';')
					{
						break;
					}
					else if (c == '=')
					{
						s = 1;
					} 
					else if (s == 1)
					{
						s = 2;
						start = i;
						end = i;
					}
					else if (s == 2)
					{
						end = i;
					}
				}
				else 
				{
					if (s == 2)
					{
						break;
					}
				}
				i ++;
			}
			
			if (start >= 0 && end >= start && end < l)
			{
				self.contentCharset = [contentType substringWithRange:NSMakeRange(start, end - start + 1)];
			}
		}
	}
}

- (void) reportConnectionStatus:(CURLDataLoader*)loader errorCode:(TUrlDataLoadErrorCode)errorCode
{
    //add by maxxiangli for 纪录返回的http header on 20130514
    if ( self.isNeedReport)
    {
        NSString * device = [[CBossReporter sharedBossReporter] getDeviceType2];
        if(device && [device hasPrefix:@"iPad"])
        {
            //ipad
            device = @"3";
        }
        else
        {
            //iphone、ipod、...
            device = @"4";
        }
        NSString * network = @"";
        switch ([CNetworkMonitor sharedNetworkMonitor].networkType) {
            case eNetworkNETwifi:
                network = @"wifi";
                break;
            case eNetworkNETwwan:
                network = [NSString stringWithFormat:@"%@", [CNetworkMonitor sharedNetworkMonitor].cellType];
                break;
            default:
                network = @"offline";
                break;
        }
        unsigned long connectTime = [self.receiveHeaderTime timeIntervalSinceDate:self.beginRequestTime]*1000;
        unsigned long transTime = [self.completeTime timeIntervalSinceDate:self.receiveHeaderTime]*1000;
        
        NSString * retCode = [NSString stringWithFormat:@"%d", errorCode];
        if(self.receiveHeaderData && [self.receiveHeaderData valueForKey:@"kStatusCode"])
        {
            retCode = [NSString stringWithFormat:@"%@", [self.receiveHeaderData valueForKey:@"kStatusCode"]];
        }
        
        NSUInteger dataLen = loader.urlData?loader.urlData.length:0;
        NSString * domain = @"";
        NSMutableString * cgi = [NSMutableString string];
        NSMutableArray * segmentArr = [NSMutableArray arrayWithArray:[self.url pathComponents]];
        if([segmentArr count] < 2)
        {
            return;
        }
        //remove http:
        if([[segmentArr objectAtIndex:0] rangeOfString:@":"].length > 0)
        {
            [segmentArr removeObjectAtIndex:0];
        }
        //get domain
        if([[segmentArr objectAtIndex:0] rangeOfString:@"."].length <= 0)
        {
            return;
        }
        domain = [NSString stringWithString:[segmentArr objectAtIndex:0]];
        [segmentArr removeObjectAtIndex:0];
        
        for(NSString * segment in segmentArr)
        {
            if([cgi length] > 0)
            {
                [cgi appendString:@"_"];
            }
            
            if([segment rangeOfString:@"?"].length > 0)
            {
                [cgi appendString:[segment substringToIndex:[segment rangeOfString:@"?"].location]];
                break;
            }
            else
            {
                [cgi appendString:segment];
            }
        }
        
//        NSMutableDictionary * report = [NSMutableDictionary dictionary];
//        [report setValue:device forKey:@"devtype"];
//        [report setValue:network forKey:@"nettype"];
//        [report setValue:@"" forKey:@"svr_ip"];
//        [report setValue:[NSString stringWithFormat:@"%lu", connectTime] forKey:@"conn_time"];
//        [report setValue:[NSString stringWithFormat:@"%lu", transTime] forKey:@"trans_time"];
//        [report setValue:domain forKey:@"domain"];
//        [report setValue:cgi forKey:@"cgi"];
//        [report setValue:retCode forKey:@"retcode"];
//        [report setValue:@"0" forKey:@"module_id"];
//        [report setValue:[NSString stringWithFormat:@"%lu", (unsigned long)dataLen] forKey:@"data_len"];
//        [report setValue:@"0" forKey:@"retry_step"];
//        [report setValue:@"1" forKey:@"retry_flag"];
//        [report setValue:[NSString stringWithFormat:@"%d", CHANNELID] forKey:@"market_id"];
//        [WDK trackCustomKeyValueEvent:@"itil_cgi_access_quality" props:report];
    }
}

- (void) urlDataLoadError:(CURLDataLoader*)loader errorCode:(TUrlDataLoadErrorCode)errorCode
{
    self.completeTime = [NSDate date];
    [self reportConnectionStatus:loader errorCode:errorCode];
    
	XLOG(@"Error: %d", errorCode);
	self.httpErrorCode = errorCode;
    
    //将http header记入日志，只有在日志手动打开的时候才会执行
    STOCK_LOG(kStockLogModuleAllRequest, kStockLogLevelData, @"%s,%p,HTTP_HEADER:%@", object_getClassName(self), self, [loader.responseHeader description]);
    
	[self performSelectorOnMainThread:@selector(requestErrorOccorredInMainThread) withObject:nil waitUntilDone:NO];
}

- (void) urlDataLoadComplete:(CURLDataLoader*)loader
{
    self.completeTime = [NSDate date];
    [self reportConnectionStatus:loader errorCode:eURLErrorNone];

//	[self.stopWatch lap:[NSString stringWithFormat:@"2、网络请求时间: %@", loader.urlStr]];
//	self.timeSlot2 = [self.stopWatch getRunningTime];
	self.httpErrorCode = eURLErrorNone;
    
    //将http header记入日志，只有在日志手动打开的时候才会执行
    STOCK_LOG(kStockLogModuleAllRequest, kStockLogLevelData, @"%s,%p,HTTP_HEADER:%@", object_getClassName(self), self, [loader.responseHeader description]);
    
    if(loader && loader.responseHeader)
    {
        NSString * kStatusCode = [loader.responseHeader objectForKey:@"kStatusCode"];
#warning 需要与后台确认是否300OK
        if(kStatusCode && [kStatusCode intValue] >= 300)
        {
            //如果http请求返回异常，则认为连接失败
            [CBossReporter trackRequest:self urlOrStatus:[NSString stringWithFormat:@"HTTP code:%@", kStatusCode]];
            [self performSelectorOnMainThread:@selector(requestErrorOccorredInMainThread) withObject:nil waitUntilDone:NO];
            return;
        }
    }
    
    NSString * responseData = nil;
    if(loader.urlData)
    {
        responseData = [self getStringFromData:loader.urlData];
        if(responseData)
        {
            [CBossReporter trackRequest:self responseData:responseData];
        }
    }
    
    @try {
        [self parserDataInThread:loader.urlData];
    }
    @catch (NSException *exception) {
        REPORT_EXCEPTION_DATA(exception, responseData);
        [CBossReporter trackRequest:self urlOrStatus:@"parserError"];
        [self performSelectorOnMainThread:@selector(requestErrorOccorredInMainThread) withObject:nil waitUntilDone:NO];
        return;
    }
    @finally {
    }
    
    [CBossReporter trackRequest:self urlOrStatus:@"parserEnd"];
    
//	[self.stopWatch lap:@"3、辅助线程中解析数据时间"];
//	[self.stopWatch startWatch];
	
	[self performSelectorOnMainThread:@selector(__requestCompleteInMainThread) withObject:nil waitUntilDone:NO];
}


- (void) requestErrorOccorredInMainThread
{
    // HttpDns被替换过后发生错误
    if(self.httpDnsRecord){
        DNSLog(@"dns failed: %@", self.httpDnsRecord);
        // 使dns记录失效
        [[HttpDnsManager sharedManager] invalidateRecord: self.httpDnsRecord];
        // 使用原来的host重试请求
        self.start = YES;
        self.httpErrorCode = eURLErrorNone;
        [[CWorkedThread sharedWorkedThread] performTarget:self selector:@selector(startRequestInThread) withObject:self];
        DNSLog(@"retry: [%@]", self.url);
        return;
    }
    
	self.start = NO;
	NSNotification* notif = [NSNotification notificationWithName:kHttpRequestErrorNotification object:[NSNumber numberWithInt:self.httpErrorCode] userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notif];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestErrored:)])
	{
		[self.delegate requestErrored:self];
	}
	[self safeRelease];
}

- (void) safeRetain
{
    me = self;
	self.isReleased = NO;
}

- (void) safeRelease
{
	if (!self.isReleased)
	{
		self.isReleased = YES;
        me = nil;
	}
}

- (void) dealloc
{
	self.urlDataLoaderProxy.delegate = nil;
	self.urlDataLoaderProxy = nil;
	self.postData = nil;
	self.stringPostData = nil;
	self.header = nil;
	self.url = nil;
	self.delegate = nil;
	self.stopWatch = nil;
	self.contentCharset = nil;
	self.beginRequestTime = nil;//add by maxxiangli for boss reporter
    self.receiveHeaderTime = nil;
    self.completeTime = nil;
    self.receiveHeaderData = nil;
    self.httpDnsRecord = nil;
    
	
}

- (BOOL) isUTF8Encoding:(const char*)srcStr len:(int)len
{
	int index = 0;
	int c = 0;
	while ((c = *(const uint8_t*)(srcStr + index)))
	{
		if ((c <= 0xF7) && ((c & 0xC0) != 0x80))
		{
			index += (((0xE5 << 24) >> (c >> 4 << 1)) & 3) + 1;
			if (index >= len)
			{
				break;
			}
		}
		else
		{
			break;
		}
	}
	return index == len;
}

- (NSString *)getStringFromData:(NSData *)recvData
{
    NSString* str = nil;
    if ([recvData length] > 0)
	{
        str = [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
        if (str == nil)
        {
            str = [[NSString alloc] initWithData:recvData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        }
	}
    
    return str;
}

- (NSString *)getRequestUrlForTest
{
	return self.url;
}
@end
