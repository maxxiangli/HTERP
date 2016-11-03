//
//  HTGlobal.h
//  HTERP
//
//  Created by li xiang on 16/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//
#import "CConfiguration.h"

#ifndef QQStock_Global_h
#define QQStock_Global_h

extern int  DISABLE_HTTPDNS;            //关闭HttpDns

#define SharedAPPDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define GLOBEL_LOGIN_OBJECT [CPortfolioLoginManager getInstance]

#define iOS7SDK	(__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)

#define currentOSVersion (NSFoundationVersionNumber)

//当前版本判断.
#define isiOS5	((currentOSVersion >= NSFoundationVersionNumber_iOS_5_0) && (currentOSVersion <= NSFoundationVersionNumber_iOS_5_1))
#define isiOS6	((currentOSVersion > NSFoundationVersionNumber_iOS_5_1) && (currentOSVersion <= NSFoundationVersionNumber_iOS_6_1))
//#define isiOS7	(currentOSVersion >= NSFoundationVersionNumber_iOS_7_0)
#define isiOS7	((currentOSVersion > NSFoundationVersionNumber_iOS_6_1) && (currentOSVersion <= NSFoundationVersionNumber_iOS_7_1))
#define isiOS8	( (currentOSVersion >= NSFoundationVersionNumber_iOS_8_0) && (currentOSVersion <= NSFoundationVersionNumber_iOS_9_0) )
#define isiOS9	(currentOSVersion >= NSFoundationVersionNumber_iOS_9_0)


#define isThaniOS6  (isiOS7 || isiOS8 || isiOS9)
#define isiOS9Later (currentOSVersion >= NSFoundationVersionNumber_iOS_9_0)
#define isiOS8Later (currentOSVersion >= NSFoundationVersionNumber_iOS_8_0)
#define isiOS7Later (currentOSVersion >= NSFoundationVersionNumber_iOS_7_0)


#define MainScreenWidth				CGRectGetWidth([UIScreen mainScreen].bounds)
#define MainScreenHeight			CGRectGetHeight([UIScreen mainScreen].bounds)

#define ScreenWidth					((MainScreenHeight > MainScreenWidth) ? MainScreenWidth : MainScreenHeight)
#define ScreenHeight				((MainScreenHeight > MainScreenWidth) ? MainScreenHeight : MainScreenWidth)

#define StatusBarHeight             [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight        44.0f

#define isiPad					(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isiPhone				(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isiPhone35inch			(isiPhone && (ScreenHeight == 480.f))
#define isiPhone4inch			(isiPhone && (ScreenHeight == 568.f))
#define isiPhone47inch			(isiPhone && (ScreenHeight == 667.f))
#define isiPhone55inch			(isiPhone && (ScreenHeight == 736.f))

#define isiPhone6				isiPhone47inch
#define isiPhone6Plus			isiPhone55inch
#define isiPhone6SPlus          isiPhone55inch


//服务器数据异常
#define ERROR_CODE_ServerDataUnExpected		(-700)
//判断服务器返回的code数值是否为0，尤其针对返回为nil、NULL、"G_INTERNAL"等
#define STOCK_PARSER_CODE_IS_ZERO(code)		((nil == code)?NO:[code isKindOfClass:[NSNumber class]]?(0==[code integerValue]):([code isKindOfClass:[NSString class]]&&[[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"]))

#define STOCK_PARSER_CODE_ERROR(code)		((nil == code)?YES:[code isKindOfClass:[NSNumber class]]?(0!=[code integerValue]):[code isKindOfClass:[NSString class]]?(![[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"]):YES)

#define STOCK_PARSER_CODE_INT_VALUE(code)	((nil == code)?ERROR_CODE_ServerDataUnExpected:[code isKindOfClass:[NSNumber class]]?[code intValue]:(![code isKindOfClass:[NSString class]])?ERROR_CODE_ServerDataUnExpected:(0 != [code intValue])?[code intValue]:[code isEqualToString:@"0"]?0:ERROR_CODE_ServerDataUnExpected)

#define STOCK_PARSER_INT_VALUE(code)		((nil == code)?0:[code isKindOfClass:[NSNumber class]]?[code integerValue]:[code isKindOfClass:[NSString class]]?[code integerValue]:0)

#define STOCK_PARSER_INTEGER_VALUE(code)		((nil == code)?0:[code isKindOfClass:[NSNumber class]]?[code integerValue]:[code isKindOfClass:[NSString class]]?[code integerValue]:0)

#define STOCK_PARSER_FLOAT_VALUE(code)		((nil == code)?0:[code isKindOfClass:[NSNumber class]]?[code floatValue]:[code isKindOfClass:[NSString class]]?[code floatValue]:0)


//将服务器返回的数据转换为字符串，尤其是针对某些本应为字符串的数据却返回别的类型，比如NULL等
#define STOCK_PARSER_STR_VALUE(data)		((nil == data)?[NSString stringWithFormat:@""]:[data isKindOfClass:[NSString class]]?data:[data isKindOfClass:[NSNumber class]]?[data stringValue]:[NSString stringWithFormat:@""])
//将服务器返回的数据转换为数组
#define STOCK_PARSER_ARRAY_VALUE(data)		((nil == data)?[NSArray array]:[data isKindOfClass:[NSArray class]]?data:[NSArray array])
//将服务器返回的数据转换为字典
#define STOCK_PARSER_DICTIONARY_VALUE(data) ((nil == data)?[NSDictionary dictionary]:[data isKindOfClass:[NSDictionary class]]?data:[NSDictionary dictionary])

//如果不是想要的数据类型，就返回nil
#define STOCK_PARSER_ARRAY_OR_NIL(data)		((nil == data)?nil:[data isKindOfClass:[NSArray class]]?data:nil)
#define STOCK_PARSER_DICTIONARY_OR_NIL(data) ((nil == data)?nil:[data isKindOfClass:[NSDictionary class]]?data:nil)

// 是否为空判断.
#define isNil(x) ((x)==nil)
#define Safe_Release(object) if(object){object = nil;}
#define Safe_Release_Request(object) if(object && [object isKindOfClass:[CRequestCommand class]]){object.delegate=nil;[object stopRequest];object = nil;}

#if (DEBUG_LOG == 1)
#	define XLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#	define XLOGDATASTR(data) XLOG(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] )
#	define XLOGRECT(rect) XLOG(@"rect[%d, %d, %d, %d]", (int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)
#	define XLOGH(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#elif (DEBUG_LOG != 0)
#	define XLOG(fmt, ...) {}
#	define XLOGDATASTR(data) {}
#	define XLOGRECT(rect) {}
#	define XLOGH(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define XLOG(fmt, ...) {}
#	define XLOGDATASTR(data) {}
#	define XLOGRECT(rect) {}
#	define XLOGH(fmt, ...) {}
#endif

//当前版本号为自动获取, 不需要人为设定. 请在Tagert上设置版本信息.
#define MAJOR_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define MINOR_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define STOCK_LOG_LEVEL_DEFAULT	0			//stock log的默认级别，正式发布前更改为0
#endif
