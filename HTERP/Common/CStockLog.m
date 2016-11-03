//
//  CDebugLog.m
//  QQStock
//
//  Created by sony on 14-2-19.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "CStockLog.h"
#import "CConfiguration.h"
#include <zlib.h>
#import "CStockLogSenderController.h"
#define LOG_OPEN_TIME   (3600*24)

void _STOCK_LOG(eStockLogModule module, eStockLogLevel level, const char * file, unsigned long line, const char * function, NSString * format, ...)
{
    int levelSetting = [CStockLog getLogLevel];
    if(0 >= levelSetting)
    {
        return;
    }
    
	if(level > levelSetting)
	{
		return;
	}
	
	va_list arglist;
    va_start(arglist, format);
    NSString * msg = [[NSString alloc ] initWithFormat:format arguments:arglist];
    va_end(arglist);
	
	NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd HH:mm:ss"];
	NSString * dateString = [dateFormat stringFromDate:[NSDate date]];
	
	
	NSString * logMessage = nil;
	NSString * filename = [[NSString stringWithFormat:@"%s", file] lastPathComponent];
	if(kStockLogLevelError == level)
	{
		logMessage = [NSString stringWithFormat:@"\n[%@][%@][%ld][%s]\n%@\n", dateString, filename, line, function, msg];
	}
	else if(kStockLogLevelWarning == level)
	{
		logMessage = [NSString stringWithFormat:@"\n[%@][%s]\n%@\n", dateString, function, msg];
	}
	else if(kStockLogLevelInfo == level)
	{
		logMessage = [NSString stringWithFormat:@"\n[%@][%s]\n%@\n", dateString, function, msg];
	}
    else if(kStockLogLevelData == level)
    {
        logMessage = [NSString stringWithFormat:@"\n[%@][%s]\n%@\n", dateString, function, msg];
    }
	
	if(logMessage)
	{
		[CStockLog addLogForModule:module level:level message:logMessage];
	}
}


@implementation CStockLog

#define _unknown_log_level -700
static int _log_level = _unknown_log_level;
static NSDate * _log_open_date = nil;

+ (NSString *)stockLogDir
{
	static NSString* debugLogDir = nil;
	if (debugLogDir == nil)
	{
		NSString * appCachePath = nil;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0)
		{
			appCachePath = [paths objectAtIndex:0];
		}
		if(nil == appCachePath)
		{
			return nil;
		}
		debugLogDir = [[NSString alloc] initWithFormat:@"%@/stocklogdir", appCachePath];
	}
	
	BOOL isDir;
	if([[NSFileManager defaultManager] fileExistsAtPath:debugLogDir isDirectory:&isDir])
	{
		if(!isDir)
		{
			return nil;
		}
	}
	else
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:debugLogDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return debugLogDir;
}

+ (NSString *)fileNameForLogSetting
{
    return @"config";
}

+ (NSString *)filePathForLogSetting
{
    NSString* debugLogDir = [self stockLogDir];
    if(nil == debugLogDir)
    {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", debugLogDir,[self fileNameForLogSetting]];
}

+ (void)setLogLevel:(int)level
{
    if(level > 0)
    {
        //更新日志打开时间
        
        _log_open_date = [NSDate date];
    }
    
    if(9 == level)
    {
        //9：关闭并删除所有log
        level = -1;
    }
    
    NSString * filePath = [self filePathForLogSetting];
    NSMutableDictionary * dict = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else
    {
        dict = [NSMutableDictionary dictionary];
    }
    
    if(dict)
    {
        [dict setValue:[NSString stringWithFormat:@"%d",level] forKey:@"level"];
        [dict writeToFile:filePath atomically:YES];
    }
    
    _log_level = level;
    
    if(-1 == level)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self stockLogDir] error:nil];
    }
}

+ (int)getLogLevelFromConfig
{
    NSString * filePath = [self filePathForLogSetting];
    NSMutableDictionary * dict = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary * attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if(attribute)
        {
            
            _log_open_date = [attribute valueForKey:NSFileModificationDate];
        }
        
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if(dict)
        {
            NSString * level = [dict valueForKey:@"level"];
            if(level && [level isKindOfClass:[NSString class]])
            {
                return [level intValue];
            }
        }

    }
    return STOCK_LOG_LEVEL_DEFAULT;
}

+ (int)getLogLevel
{
    if(_unknown_log_level == _log_level)
    {
        _log_level = [CStockLog getLogLevelFromConfig];
    }
    return _log_level;
}

//文件格式：community_error_201401
+ (NSString *)logFilePathForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString
{
	NSString* debugLogDir = [self stockLogDir];
	if(nil == debugLogDir)
	{
		return nil;
	}
	
	NSString * moduleName = nil;
	NSString * levelName = nil;
	switch (module) {
		case kStockLogModuleCommunity:
			moduleName = @"community";
			break;
		case kStockLogModuleStockDetail:
			moduleName = @"stockdetail";
			break;
		case kStockLogModuleImageCache:
			moduleName = @"imagecache";
			break;
        case kStockLogModuleAllRequest:
            moduleName = @"request";
            break;
		default:
			moduleName = @"any";
			break;
	}
	switch (level) {
		case kStockLogLevelError:
			levelName = @"error";
			break;
		case kStockLogLevelWarning:
			levelName = @"warning";
			break;
		case kStockLogLevelInfo:
			levelName = @"info";
			break;
        case kStockLogLevelData:
            levelName = @"data";
            break;
		default:
			levelName = @"any";
			break;
	}
	
	return [NSString stringWithFormat:@"%@/%@_%@_%@", debugLogDir, moduleName, levelName, dateString];
}


+ (NSArray *)stockLogFileList
{
    NSString * logDir = [CStockLog stockLogDir];
    NSArray * fileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDir error:nil];
    
    if(fileArr && [fileArr count] > 0)
    {
        NSMutableArray * retArr = [NSMutableArray arrayWithArray:fileArr];
        for(NSString * fileName in retArr)
        {
            if([fileName isEqualToString:[self fileNameForLogSetting]])
            {
                [retArr removeObject:fileName];
                return retArr;
            }
        }
    }
    
    return [NSArray array];
}

+ (NSString *)logFilePathForModule:(eStockLogModule)module level:(eStockLogLevel)level
{
	NSDateFormatter * format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyyMMdd"];
	NSString * dateString = [format stringFromDate:[NSDate date]];
	
	
	return [self logFilePathForModule:module level:level dateString:dateString];
}

+ (void)addLogForModule:(eStockLogModule)module level:(eStockLogLevel)level message:(NSString *)message
{
    if(level != kStockLogLevelData || module != kStockLogModuleAllRequest)
    {
        //当前版本只保留一个级别的log，即记录所有网络数据，其它级别的待后续完善后再打开
        return;
    }
    
    if(level > _log_level)
    {
        return;
    }
    
    if(_log_open_date && 0 - [_log_open_date timeIntervalSinceNow] > LOG_OPEN_TIME)
    {
        //如果日志已经打开超过一天，则自动关闭日志
        [self setLogLevel:0];
        return;
    }
    
	if(nil == message || [message length] <= 0)
	{
		return;
	}
	
	NSString * filePath = [self logFilePathForModule:module level:level];
	if(nil == filePath)
	{
		return;
	}
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData dataWithBytes:[filePath UTF8String] length:strlen([filePath UTF8String])] attributes:nil];
        NSArray * fileList = [self stockLogFileList];
        NSString * logDir = [self stockLogDir];
        for(NSString * fileName in fileList)
        {
            NSString * filePath = [logDir stringByAppendingPathComponent:fileName];
            NSDictionary * attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            if(attribute && [attribute valueForKey:NSFileModificationDate])
            {
                NSDate * date = [attribute valueForKey:NSFileModificationDate];
                if(0 - [date timeIntervalSinceNow] > 3600*24*7)
                {
                    //超过7天的文件，删除掉
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                }
            }
        }
	}
	
	NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	if(handle)
	{
		const char* c_str = [message UTF8String];
		if (c_str != NULL)
		{
			NSData* data = [[NSData alloc] initWithBytes:c_str length:strlen(c_str)];
			[handle seekToEndOfFile];
			[handle writeData:data];
			
		}
		[handle closeFile];
	}
}

+ (NSString *)logFileNameForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString
{
	NSString * filePath = [self logFilePathForModule:module level:level dateString:dateString];
	return [filePath lastPathComponent];
}

+ (NSString *)logContentForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString
{
	NSString * filePath = [self logFilePathForModule:module level:level dateString:dateString];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	}
	return nil;
}

+ (void)sendLogForModule:(eStockLogModule)module level:(eStockLogLevel)level dateString:(NSString *)dateString
{
    NSString * filePath = [self logFilePathForModule:module level:level dateString:dateString];
    [CStockLogSenderController sendFile:filePath];
}

+ (void)sendLogFilePath:(NSString *)filePath
{
    [CStockLogSenderController sendFile:filePath];
}

+ (NSDate *)getLogCloseDate
{
    if(_log_open_date)
    {
        return [NSDate dateWithTimeInterval:LOG_OPEN_TIME sinceDate:_log_open_date];
    }
    return nil;
}

@end