//
//  CStockLog.h
//  QQStock
//
//  Created by sony on 14-2-19.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDebugLogFileSuffixForDebug
#define kDebugLogFilePrefixForCommunity	@"community"

typedef enum{
	kStockLogLevelError = 1,
	kStockLogLevelWarning = 2,
	kStockLogLevelInfo = 3,
    kStockLogLevelData = 4,
}eStockLogLevel;

//请顺序添加到最后，不要insert。
typedef enum{
	kStockLogModuleCommunity = 0,
	kStockLogModuleStockDetail,
	kStockLogModuleNumber,
	kStockLogModuleImageCache,
    kStockLogModuleAllRequest,
    kStockLogModuleLogin
}eStockLogModule;

extern void _STOCK_LOG(eStockLogModule module, eStockLogLevel level, const char * file, unsigned long line, const char * function, NSString * format, ...);

#define STOCK_LOG(module,level,format,...)		_STOCK_LOG(module,level,__FILE__, __LINE__, __FUNCTION__, format, ##__VA_ARGS__)

@interface CStockLog : NSObject
+ (void)setLogLevel:(int)level;
+ (int)getLogLevel;
+ (void)addLogForModule:(eStockLogModule)module level:(eStockLogLevel)level message:(NSString *)message;
+ (NSString *)logFilePathForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString;
+ (NSString *)logFileNameForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString;
+ (NSString *)logContentForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString;
+ (void)sendLogForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString;
+ (void)sendLogFilePath:(NSString *)filePath;

+ (NSString *)stockLogDir;
+ (NSArray *)stockLogFileList;

+ (NSDate *)getLogCloseDate;
@end
