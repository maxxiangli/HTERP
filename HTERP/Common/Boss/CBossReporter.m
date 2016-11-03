//
//  CBossReporter.m
//  QQStock
//
//  Created by suning wang on 12-2-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "CBossReporter.h"
//#import "CDataCache.h"
//#import "CPortfolioHandler.h"

#include <sys/utsname.h>
//#import "CDESUtil.h"

#define kBossReportUrl                      @"http://btrace.qq.com/collect"
//需要上传的数据
#define kPostDataFilePath                   @"postData.value"
#define kVersionFilePath                    @"version.value"

#define kDataEncodeKey                      @"boss@!12"
#define kDataEncodeKIV                      "12345678"
#define kProtocolVersion                    @"1"
#define kDeviceTypeID                       @"1411"
#define kRunInfoTypeID                      @"1444"
#define kTickInfoTypeID                     @"1447"

//字符串替换逗号
#define REPLACECOMMA(str)                   [str stringByReplacingOccurrencesOfString:@"," withString:@"_"]

@interface CBossReporter ()
@property (nonatomic,retain) NSString * deviceType2;
@property (nonatomic,retain) NSMutableString * eventTrackStack;
@property (nonatomic,retain) NSMutableString * requestTrackStack;
@property (nonatomic,retain) NSMutableString * requestResponseData;
@end
@implementation CBossReporter
@synthesize deviceType2;

static CBossReporter *_sharedBossReporter = nil;

static BOOL _enableAlertForMumu = NO;//是否弹框：为木木测试使用，从smartbox中隐藏，默认为false
+(void)enableAlertForMumu:(BOOL)enable
{
    _enableAlertForMumu = enable;
}

+ (CBossReporter *)sharedBossReporter
{
	if (!_sharedBossReporter)
	{
		_sharedBossReporter = [[CBossReporter alloc] init];
        _sharedBossReporter.eventTrackStack = [NSMutableString string];
        _sharedBossReporter.requestTrackStack = [NSMutableString string];
        _sharedBossReporter.requestResponseData = [NSMutableString string];
	}
	return _sharedBossReporter;
}

+ (id)alloc
{
	NSAssert(_sharedBossReporter == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void)purgeSharedBossReporter
{
	
	_sharedBossReporter = nil;
}

+ (NSDictionary*) _reportCommonDataWithEvent:(NSDictionary*) kv {

//    NSString * loginID = GLOBEL_LOGIN_OBJECT.userLoginUin;
//    if(!loginID)
//    {
//        loginID = @"10000";
//    }
//    NSString * loginType = @"NO";
//    switch (GLOBEL_LOGIN_OBJECT.portfolioLoginType) {
//        case eLoginTypeWT:
//            loginType = @"QQ";
//            break;
//        case EloginTypeWx:
//            loginType = @"WX";
//            break;
//        default:
//            loginType = @"NO";
//            break;
//    }
//    
//        
//    NSMutableDictionary *data = [@{ @"omgid": stringValueNotNil([CConfiguration sharedConfiguration].omgID),
//                                     @"omgbizid": stringValueNotNil([CConfiguration sharedConfiguration].omgBizID),
//                                     @"logintype": loginType,
//                                     @"qq": loginID
//                                     } mutableCopy];
//
//    if (dictionaryValue(kv)) {
//        [data addEntriesFromDictionary:kv];
//    }
//    return data;
    return nil;
}

+ (void)reportTickInfo:(TReportType)reportType
{
    [CBossReporter trackUserEvent:[NSString stringWithFormat:@"%lu", (unsigned long)reportType]];
    
    //[WDK trackCustomEvent:[NSString stringWithFormat:@"%lu", (unsigned long)reportType] args:nil];
}

+ (void)reportTickInfo:(NSString *)reportKey props:(NSDictionary*)kvs
{
    if ( [reportKey isKindOfClass:[NSString class]] )
    {
        NSDictionary *kvsData = [self _reportCommonDataWithEvent:kvs];
//        [WDK trackCustomKeyValueEvent:reportKey props:kvsData];
    }
    if(_enableAlertForMumu)
    {
        [[[UIAlertView alloc] initWithTitle:@"BOSS alert" message:reportKey delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]  show];
    }
}

+ (void)reportTickInfoReportType:(TReportType)reportType props:(NSDictionary*)kvs
{
    NSDictionary *kvsData = [self _reportCommonDataWithEvent:kvs];
//    [WDK trackCustomKeyValueEvent:[NSString stringWithFormat:@"%lu", (unsigned long)reportType] props:kvsData];
    if(_enableAlertForMumu)
    {
        [[[UIAlertView alloc] initWithTitle:@"BOSS alert"
                                     message:[NSString stringWithFormat:@"%ld",(unsigned long)reportType] delegate:nil cancelButtonTitle:@"OK"
                           otherButtonTitles: nil] show];
    }
}

+ (void)reportUserEvent:(NSString *)userEvent
{
    [CBossReporter trackUserEvent:[NSString stringWithFormat:@"%@", userEvent]];

    NSDictionary *kvsData = [self _reportCommonDataWithEvent:nil];
//    [WDK trackCustomKeyValueEvent:userEvent props:kvsData];
    
    if(_enableAlertForMumu)
    {
        [[[UIAlertView alloc] initWithTitle:@"BOSS alert" message:[NSString stringWithFormat:@"%@ \n%@", userEvent, [kvsData description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]  show];
    }
}

+ (void)reportUserEvent:(NSString *)userEvent stockCode:(NSString *)stockCode
{
    if(nil == stockCode || ![stockCode isKindOfClass:[NSString class]])
    {
        stockCode = @"";
    }
    
    [CBossReporter trackUserEvent:[NSString stringWithFormat:@"%@_%@", userEvent, stockCode]];

    NSDictionary *kvsData = [self _reportCommonDataWithEvent:[NSDictionary dictionaryWithObject:stockCode forKey:@"stockID"]];
    
//    [WDK trackCustomKeyValueEvent:userEvent props:kvsData];
    
    if(_enableAlertForMumu)
    {
        [[[UIAlertView alloc] initWithTitle:@"BOSS alert" message:[NSString stringWithFormat:@"%@ stockID:%@ \n%@",userEvent,stockCode,[kvsData description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]  show];
    }
}

+ (void)reportUserEvent:(NSString *)userEvent keyValues:(NSDictionary *)keyValues
{
    [CBossReporter trackUserEvent:userEvent];
    
    NSDictionary *kvsData = [self _reportCommonDataWithEvent:keyValues];
//    [WDK trackCustomKeyValueEvent:userEvent props:kvsData];
    
    if(_enableAlertForMumu)
    {
        [[[UIAlertView alloc] initWithTitle:@"BOSS alert" message:[NSString stringWithFormat:@"%@ keyValues:%@",userEvent, [kvsData description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]  show];
    }
}

+ (void)reportDeviceInfo
{
    NSString *model = [[CBossReporter sharedBossReporter] getDeviceType2];
    if(nil == model)
    {
        model = [NSString stringWithFormat:@"unknown"];
    }
    
    if([model isEqualToString:@"iPhone7,1"])
    {
        NSDictionary *kvsData = [self _reportCommonDataWithEvent:nil];
        
//        if([UIScreen mainScreen].bounds.size.height > 667+10)
//        {
//            [WDK trackCustomKeyValueEvent:@"device_6p_normal" props:kvsData];
//        }
//        else
//        {
//            [WDK trackCustomKeyValueEvent:@"device_6p_zoom" props:kvsData];
//        }
    }
}

+ (void)reportPortfolioUin
{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
//    NSString *qqUin = @"10000";
//    NSString *wxuin = @"10000";
//	NSString *nickName = @"";
//	NSString *loginType = @"notLogin";
//    
//    if ( GLOBEL_LOGIN_OBJECT.isPortFolioLogin )
//    {
//        if ( GLOBEL_LOGIN_OBJECT.userLoginUin )
//        {
//            qqUin = GLOBEL_LOGIN_OBJECT.userLoginUin;
//        }
//        
//        if ( GLOBEL_LOGIN_OBJECT.openId )
//        {
//            wxuin = GLOBEL_LOGIN_OBJECT.openId;
//        }
//		
//		if ( GLOBEL_LOGIN_OBJECT.nickName )
//		{
//			nickName = GLOBEL_LOGIN_OBJECT.nickName;
//		}
//		
//		if ( eLoginTypeWT == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
//		{
//			loginType = @"QQLogin";
//		}
//		else if ( EloginTypeWx == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
//		{
//			loginType = @"WXLogin";
//		}
//		else
//		{
//			loginType = @"notLogin";
//		}
//    }
//	
//	[dic setObject:loginType forKey:@"LoginType"];
//	[dic setObject:qqUin forKey:@"QQUin"];
//	[dic setObject:wxuin forKey:@"WXOpendId"];
//	[dic setObject:nickName forKey:@"NickName"];
//    
//    [CBossReporter reportTickInfoReportType:eRepTypeLoginUinPortfolio props:dic];
//
//    [WDK reportQQ:qqUin];
}

+ (void)reportStockMomentsUin
{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
//    NSString *qqUin = @"20000";
//    NSString *wxuin = @"20000";
//    NSString *nickName = @"";
//	NSString *loginType = @"notLogin";
//	
//    if ( GLOBEL_LOGIN_OBJECT.isStockMomentsLogin )
//    {
//        if ( GLOBEL_LOGIN_OBJECT.wxuserLoginUin )
//        {
//            qqUin = GLOBEL_LOGIN_OBJECT.wxuserLoginUin;
//        }
//        
//        if ( GLOBEL_LOGIN_OBJECT.wxopenId )
//        {
//            wxuin = GLOBEL_LOGIN_OBJECT.wxopenId;
//        }
//		
//		if ( GLOBEL_LOGIN_OBJECT.wxnickName )
//		{
//			nickName = GLOBEL_LOGIN_OBJECT.wxnickName;
//		}
//		
//		if ( eLoginTypeWT == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
//		{
//			loginType = @"QQLogin";
//		}
//		else if ( EloginTypeWx == GLOBEL_LOGIN_OBJECT.portfolioLoginType )
//		{
//			loginType = @"WXLogin";
//		}
//		else
//		{
//			loginType = @"notLogin";
//		}
//    }
//	
//	[dic setObject:loginType forKey:@"LoginType"];
//	[dic setObject:qqUin forKey:@"QQUin"];
//	[dic setObject:wxuin forKey:@"WXOpendId"];
//	[dic setObject:nickName forKey:@"NickName"];
//    
//    [CBossReporter reportTickInfoReportType:eRepTypeLoginUinstockMoments props:dic];
}

+ (NSString*) getDeviceType22
{
	struct utsname u;
	uname(&u);
	
	NSString *platform = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
	platform = platform == nil ? [UIDevice currentDevice].model : platform;
    
	if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
	if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
	if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
	if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
	if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
	if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
	if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
	if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
	if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
	if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
	if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
	if ([platform isEqualToString:@"i386"])         return @"Simulator";
    
	return platform;
}


+ (NSString*) getDeviceTypeString
{
    struct utsname u;
    uname(&u);
    
    NSString *platform = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
    platform = platform == nil ? [UIDevice currentDevice].model : platform;
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone6SPlus";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone6S";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod6G";
    
    if ([platform isEqualToString:@"iPad1,1"] || [platform isEqualToString:@"iPad1,2"])      return @"iPad1G";
    if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"])      return @"iPad2G";
    if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"])      return @"iPadMini1G";
    if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"])      return @"iPad3G";
    if ([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"])      return @"iPad4G";
    if ([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"])      return @"iPadAir1G";
    if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"])      return @"iPadMini2G";
    if ([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] || [platform isEqualToString:@"iPad4,9"])      return @"iPadMini3G";
    if ([platform isEqualToString:@"iPad5,3"] || [platform isEqualToString:@"iPad5,4"])      return @"iPadAir2G";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return @"UnknowDevice";
}

+ (iPhoneTypes) getDeviceType {
    struct utsname u;
    uname(&u);
    
    NSString *platform = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
    platform = platform == nil ? [UIDevice currentDevice].model : platform;
    
    if ([platform isEqualToString:@"iPhone1,1"])    return iPhone1G;
    if ([platform isEqualToString:@"iPhone1,2"])    return iPhone3G;
    if ([platform isEqualToString:@"iPhone2,1"])    return iPhone3GS;
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"])    return iPhone4;
    if ([platform isEqualToString:@"iPhone4,1"])    return iPhone4S;
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])    return iPhone5;
    if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"])    return iPhone5C;
    if ([platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"])    return iPhone5S;
    if ([platform isEqualToString:@"iPhone7,1"])    return iPhone6Plus;
    if ([platform isEqualToString:@"iPhone7,2"])    return iPhone6;
    
    if ([platform isEqualToString:@"iPhone8,1"])    return iPhone6SPlus;
    if ([platform isEqualToString:@"iPhone8,2"])    return iPhone6S;
    
    
    if ([platform isEqualToString:@"iPod1,1"])      return iPod1G;
    if ([platform isEqualToString:@"iPod2,1"])      return iPod2G;
    if ([platform isEqualToString:@"iPod3,1"])      return iPod3G;
    if ([platform isEqualToString:@"iPod4,1"])      return iPod4G;
    if ([platform isEqualToString:@"iPod5,1"])      return iPod5G;
    if ([platform isEqualToString:@"iPod7,1"])      return iPod6G;
    
    if ([platform isEqualToString:@"iPad1,1"] || [platform isEqualToString:@"iPad1,2"])      return iPad1G;
    if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"])      return iPad2G;
    if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"])      return iPadMini1G;
    if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"])      return iPad3G;
    if ([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"])      return iPad4G;
    if ([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"])      return iPadAir1G;
    if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"])      return iPadMini2G;
    if ([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] || [platform isEqualToString:@"iPad4,9"])      return iPadMini3G;
    if ([platform isEqualToString:@"iPad5,3"] || [platform isEqualToString:@"iPad5,4"])      return iPadAir2G;
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])       return Simulator;
    
    return UnknowDevice;
}

+ (BOOL)isBigScreenIphone
{
    if ( iPhone6Plus == [CBossReporter getDeviceType]
        || iPhone6SPlus == [CBossReporter getDeviceType]
        )
    {
        return YES;
    }
    
    return NO;
}


- (NSString*) getDeviceType2
{
    if(nil == self.deviceType2)
    {
        self.deviceType2 = [CBossReporter getDeviceType22];
    }
    return self.deviceType2;
}

- (NSString *)getBundleVersion
{
	return MAJOR_VERSION;
}

//上报页面停留时间
+(void)trackPageViewBegin:(TReportType)reportType
{
//	[WDK trackPageViewBegin:[NSString stringWithFormat:@"%lu", (unsigned long)reportType]];
}

+(void)trackPageViewEnd:(TReportType)reportType
{
//	[WDK trackPageViewEnd:[NSString stringWithFormat:@"%lu", (unsigned long)reportType]];
}

+(void)trackUserEvent:(NSString *)event
{
    if(nil == event || NO == [event isKindOfClass:[NSString class]])
    {
        return;
    }
    
    @synchronized([CBossReporter sharedBossReporter].eventTrackStack){
        [[CBossReporter sharedBossReporter].eventTrackStack appendFormat:@"[%ld,%@]", (long)[NSDate timeIntervalSinceReferenceDate],event];
        NSUInteger len = [[CBossReporter sharedBossReporter].eventTrackStack length];
        if(len > 500)
        {
            [[CBossReporter sharedBossReporter].eventTrackStack deleteCharactersInRange:NSMakeRange(0, 200)];
        }
    }
}

+(void)trackRequest:(CRequestCommand *)request urlOrStatus:(NSString *)urlOrStatus
{
    if(nil == urlOrStatus)
    {
        return;
    }
    
    STOCK_LOG(kStockLogModuleAllRequest, kStockLogLevelInfo, @"%s,%p,%@", object_getClassName(request), request, urlOrStatus);
    STOCK_LOG(kStockLogModuleAllRequest, kStockLogLevelData, @"%s,%p,%@", object_getClassName(request), request, urlOrStatus);
    
    //大部分URL长度在150以内
    if([urlOrStatus length] > 200)
    {
        urlOrStatus = [urlOrStatus substringToIndex:150];
    }
    @synchronized([CBossReporter sharedBossReporter].requestTrackStack){
        [[CBossReporter sharedBossReporter].requestTrackStack appendFormat:@"[%ld,%s,%p,%@]\n", (long)[NSDate timeIntervalSinceReferenceDate], object_getClassName(request), request, urlOrStatus];
        NSUInteger len = [[CBossReporter sharedBossReporter].requestTrackStack length];
        if(len > 1000)
        {
            [[CBossReporter sharedBossReporter].requestTrackStack deleteCharactersInRange:NSMakeRange(0, 300)];
        }
    }
}

+(void)trackRequest:(CRequestCommand *)request responseData:(NSString *)responseData
{
    if(nil == responseData)
    {
        return;
    }
    
    if(!request.enableLogResponseForDetectError)
    {
        //不需要记录
        return;
    }
    
    if([CStockLog getLogLevel] >= kStockLogLevelData)
    {
        //远程控制CRemoteControlRequest 15K左右
        //smartbox CSmartBoxUpdateRequest：200K以上
        //自选列表CPortfolioSequenceRequest 12K左右，短行情CStockShortQuoteRequest 45K
        //CNewsListSelectedRequestCommand：73K，
        NSUInteger sizeValue = [responseData length];
        NSString * sizeDesc = @"LITTLE_FILE";
        if(sizeValue > 512000)
        {
            //500K-
            sizeDesc = @"BIG_FILE_500K";
        }
        if(sizeValue > 102400)
        {
            //100K－500K
            sizeDesc = @"BIG_FILE_100K";
        }
        else if(sizeValue > 51200)
        {
            //50K－100K
            sizeDesc = @"BIG_FILE_50K";
        }
        else if(sizeValue > 10240)
        {
            //10K－50K
            sizeDesc = @"NORMAL_FILE";
        }
        else if(sizeValue > 1024)
        {
            //1K－10K
            sizeDesc = @"SMALL_FILE";
        }
        else
        {
            //1K以下
            sizeDesc = @"LITTLE_FILE";
        }
        STOCK_LOG(kStockLogModuleAllRequest, kStockLogLevelData, @"%s,%p,%@,%@,%@", object_getClassName(request), request, sizeDesc,request.url, responseData);
    }
    
    if([responseData length] > 500)
    {
        responseData = [responseData substringToIndex:300];
    }
    @synchronized([CBossReporter sharedBossReporter].requestResponseData){
        NSUInteger len = [[CBossReporter sharedBossReporter].requestResponseData length];
        if(len > 1000)
        {
            [[CBossReporter sharedBossReporter].requestResponseData deleteCharactersInRange:NSMakeRange(0, 600)];
        }
        [[CBossReporter sharedBossReporter].requestResponseData appendFormat:@"[%ld,%s,%p,%@]\n", (long)[NSDate timeIntervalSinceReferenceDate], object_getClassName(request), request, responseData];
    }
}

+(NSString *)filePathForUncaughtException
{
    static NSString * filePath = nil;
    if(nil == filePath)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0)
        {
            filePath = [[NSString alloc] initWithFormat:@"%@/QQStockUncaughtException_%@", [paths objectAtIndex:0], MAJOR_VERSION];
        }
    }
    return filePath;
}

+(void)processLastUncaughtException
{
    //上传未捕捉异常到服务器
    NSString * filePath = [CBossReporter filePathForUncaughtException];
    if(filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString * errMsg = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if(errMsg)
        {
//            [MTA trackError:errMsg];
        }
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

//将未捕捉异常保存到文件
+(void)saveUncaughtException:(NSException *)exception
{
//    //未捕捉异常，QQ号排在最前边
//    
//    if(nil == exception)
//    {
//        return;
//    }
//    
//    NSString *appVersion = [NSString stringWithFormat:@"%@.%@", MAJOR_VERSION, MINOR_VERSION];
//    NSString *model = [[CBossReporter sharedBossReporter] getDeviceType2];
//    NSString *iosV = [UIDevice currentDevice].systemVersion;
//    NSString *deviceid = [MTA getMtaUDID];
//    NSString *uin = GLOBEL_LOGIN_OBJECT.userLoginUin ? GLOBEL_LOGIN_OBJECT.userLoginUin : @"10000";
//    NSString *wxuin = GLOBEL_LOGIN_OBJECT.wxuserLoginUin ? GLOBEL_LOGIN_OBJECT.wxuserLoginUin : @"20000";
//    
//    NSString *errlog = [NSString stringWithFormat:@"CRASH QQ%@ %@ %@ %@ %@ %@\ntime:%ld\nEVNT:%@\nRQST:%@\nDATA:%@\n%@\n%@\n--------\n%@\n--------\n%@",
//                        uin, deviceid, wxuin, appVersion, model, iosV,
//                        (long)[NSDate timeIntervalSinceReferenceDate],
//                        [CBossReporter sharedBossReporter].eventTrackStack,
//                        [CBossReporter sharedBossReporter].requestTrackStack,
//                        [CBossReporter sharedBossReporter].requestResponseData,
//                        exception.name,
//                        exception.reason,
//                        exception.callStackSymbols,
//                        exception.callStackReturnAddresses];
//    [errlog writeToFile:[CBossReporter filePathForUncaughtException] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void)reportException:(NSException *)exception file:(const char *)file function:(const char *)function line:(unsigned long)line data:(NSString*)data
{
//    //定位未知异常，QQ号排在最前边
//    return;//不再上报诊断异常
//    
//    if(nil == exception)
//    {
//        return;
//    }
//
//    if(nil == data || NO == [data isKindOfClass:[NSString class]])
//    {
//        data = [NSString stringWithFormat:@""];
//    }
//    
//    if([data length] > 500)
//    {
//        data = [data substringToIndex:300];
//    }
//    
//    NSString *appVersion = [NSString stringWithFormat:@"%@.%@", MAJOR_VERSION, MINOR_VERSION];
//    NSString *model = [[CBossReporter sharedBossReporter] getDeviceType2];
//    NSString *iosV = [UIDevice currentDevice].systemVersion;
//    NSString *deviceid = [MTA getMtaUDID];
//    NSString *uin = GLOBEL_LOGIN_OBJECT.userLoginUin ? GLOBEL_LOGIN_OBJECT.userLoginUin : @"10000";
//    NSString *wxuin = GLOBEL_LOGIN_OBJECT.wxuserLoginUin ? GLOBEL_LOGIN_OBJECT.wxuserLoginUin : @"20000";
//    
//    NSString *errlog = [NSString stringWithFormat:@"DIAG QQ%@ %s %ld %@\n %@ %@ %@ %@ %@\ntime:%ld\nEVNT:%@\nRQST:%@\n%@\n%@\n--------\n%@\n--------\n%@",
//                        uin, function, line, data,
//                        deviceid, wxuin, appVersion, model, iosV,
//                        (long)[NSDate timeIntervalSinceReferenceDate],
//                        [CBossReporter sharedBossReporter].eventTrackStack,
//                        [CBossReporter sharedBossReporter].requestTrackStack,
//                        exception.name,
//                        exception.reason,
//                        exception.callStackSymbols,
//                        exception.callStackReturnAddresses];
//    [MTA trackError:errlog];
}

+ (void)reportJsonDataError:(NSString *)errMsg
{
//    //后台数据json错误，错误类型排在最前边
//    NSString *appVersion = [NSString stringWithFormat:@"%@.%@", MAJOR_VERSION, MINOR_VERSION];
//    NSString *model = [[CBossReporter sharedBossReporter] getDeviceType2];
//    NSString *iosV = [UIDevice currentDevice].systemVersion;
//    NSString *deviceid = [MTA getMtaUDID];
//    NSString *uin = GLOBEL_LOGIN_OBJECT.userLoginUin ? GLOBEL_LOGIN_OBJECT.userLoginUin : @"10000";
//    NSString *wxuin = GLOBEL_LOGIN_OBJECT.wxuserLoginUin ? GLOBEL_LOGIN_OBJECT.wxuserLoginUin : @"20000";
//    
//    NSString *errlog = [NSString stringWithFormat:@"%@\n QQ%@ %@ %@ %@ %@ %@\n",
//                        errMsg,
//                        uin, deviceid, wxuin, appVersion, model, iosV];
//    [MTA trackError:errlog];
}

- (void)jsonDataError:(NSNotification *)note
{
    if(note && note.userInfo && [note.userInfo count])
    {
        NSString * msg = [[note.userInfo allValues] objectAtIndex:0];
        
        [CBossReporter reportJsonDataError:msg];
    }
}

- (void)jsonDataNULL:(NSNotification *)note
{
    if(note && note.userInfo && [note.userInfo count])
    {
        NSString * msg = [[note.userInfo allValues] objectAtIndex:0];
        [CBossReporter reportJsonDataError:msg];
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.deviceType2 = nil;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsonDataError:) name:STOCK_NOTICE_JSON_DECODE_ERROR object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsonDataNULL:) name:STOCK_NOTICE_JSON_DECODE_NULL object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.deviceType2 = nil;
    
}

@end
