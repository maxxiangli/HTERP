//
//  HTConfiguration.m
//  HTERP
//
//  Created by li xiang on 16/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CConfiguration.h"

#define kImageCacheFolderName				@"ImageCache"
#define kSettingKLinesHollowType            @"kLinesHollowType"     //K线空心设置
#define kStockDataCacheFolderName			@"StockDataCache"
#define kSmartBoxCacheFolderName			@"SmartBoxCache"
#define kTradingCacheFolderName				@"TradingCache"
#define kHuShenCacheFolderName				@"HuShenTradeCache"
#define kTradingSaveAccountZYGJ				@"tradingSaveAccountZYGJ"
#define kTradingAccountZYGJ					@"tradingAccountZYGJ"
#define kStockCodeKeyboradType				@"stockCodeKeyboradType"
#define kTradingStockCodeKeyboardType		@"tradingStockCodeKeyboardType"
#define kUserClickedHKNotAutoRefreshTip		@"UserClickedHKNotAutoRefreshTip"
#define kNeedSync							@"NeedSync"
#define kSettingVersion						@"SettingVersion"
#define kModFuquanFlag						@"ModFuquanFlag"
#define kDisableActivityMessage				@"DisableActivityMessage"
#define kShowProfitLossSummary				@"kShowProfitLossSummary"
#define kShowProfitLossCurrencyType         @"kShowProfitLossCurrencyType"
//modify by maxxiangli for bug id 57413903 on 2016.02.18
//#define kShowPorfolioFreshBtn				@"kShowPorfolioFreshBtn"
#define kShowPorfolioFreshBtnModified       @"kShowPorfolioFreshBtnModified"
#define kShowPorfolioFreshBtn				@"kShowPorfolioFreshBtn_new"

@implementation CConfiguration
static CConfiguration* _sharedConfiguration = nil;
+ (CConfiguration*) sharedConfiguration
{
    if (_sharedConfiguration == nil)
    {
        _sharedConfiguration = [[CConfiguration alloc] init];
        _sharedConfiguration.themeType = eThemeBlueWhite;
    }
    return _sharedConfiguration;
}

- (NSString*) getAppDocPath
{
    static NSString* sAPPDOCPATH = nil;
    if (sAPPDOCPATH == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0)
        {
            sAPPDOCPATH = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
        }
    }
    return sAPPDOCPATH;
}

- (NSString*) getAppCachePath
{
    static NSString* sAPPCACHEPATH = nil;
    if (sAPPCACHEPATH == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0)
        {
            sAPPCACHEPATH = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
        }
    }
    return sAPPCACHEPATH;
}

- (NSString*) getFullPath:(NSString*) filename pathtype:(TPathType)type
{
    if(([filename length] > 0) && ([filename characterAtIndex:0] == '/'))
    {
        return filename;
    }
    
    NSString* tFullPath = nil;
    if (type == kPathForDocument)
    {
        NSString* tRootPath = [self getAppDocPath];
        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, filename];
    }
    else if (type == kPathForCache)
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, filename];
    }
    else if (type == kPathForImageCache)
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/%@/%@", tRootPath, kImageCacheFolderName, filename];
    }
    else if (type == kPathForBundle)
    {
        tFullPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    }
    else if ( type == kPathForFileCache )
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/FileCache/%@", tRootPath, filename];
    }
    else if ( type == kPathForDBCache )
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/DBCache/%@", tRootPath, filename];
    }
    else if ( type == kPathForNewsCache )
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/NewsCache/%@", tRootPath, filename];
    }
    else if ( type == kPathForStockDataCache )
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/%@/%@", tRootPath, kStockDataCacheFolderName, filename];
    }
    else if ( type == kPathForSmartBoxCache )//add by max for smarBox数据库目录
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/%@/%@", tRootPath, kSmartBoxCacheFolderName, filename];
    }
    else if ( type == kPathForTradingCache )
    {
        NSString* tRootPath = [self getAppCachePath];
        tFullPath = [NSString stringWithFormat:@"%@/%@/%@", tRootPath, kTradingCacheFolderName, filename];
    }
//    else if ( kPathForCommunityCache == type)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@/Community/%@",
//                     tRootPath, GetProfileNameForCommunity(), filename];
//    }
    else
    {
        NSAssert(NO, @"参数错误");
    }
    return tFullPath;
}

- (NSString*) getPathByType:(TPathType)type
{
//    NSString* tFullPath = nil;
//    if (type == kPathForDocument)
//    {
//        tFullPath = [self getAppDocPath];
//    }
//    else if (type == kPathForCache)
//    {
//        tFullPath = [self getAppCachePath];
//    }
//    else if (type == kPathForImageCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, kImageCacheFolderName];
//    }
//    else if (type == kPathForBundle)
//    {
//        tFullPath = [[NSBundle mainBundle] bundlePath];
//    }
//    else if ( type == kPathForFileCache )
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/FileCache/", tRootPath];
//    }
//    else if ( type == kPathForDBCache )
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/DBCache/", tRootPath];
//    }
//    else if (type == kPathForNewsCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@/", tRootPath, kNewsCacheFolderName];
//    }
//    else if (type == kPathForPdfCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@/", tRootPath, kPdfCacheFolderName];
//    }
//    else if (type == kPathForStockDataCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, kStockDataCacheFolderName];
//    }
//    else if (type == kPathForSmartBoxCache)//add by max for smarBox数据库目录
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, kSmartBoxCacheFolderName];
//    }
//    else if (type == kPathForTradingCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, kTradingCacheFolderName];
//    }
//    else if (type == kPathForHuShenTradeCache)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@", tRootPath, kHuShenCacheFolderName];
//    }
//    else if (kPathForCommunityCache == type)
//    {
//        NSString* tRootPath = [self getAppDocPath];
//        tFullPath = [NSString stringWithFormat:@"%@/%@/Community",
//                     tRootPath, GetProfileNameForCommunity()];
//    }
//    else if (kPathForStockCommentCache == type)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/StockComment", tRootPath];
//    }else if (kPathForHowbuyFundCache == type)
//    {
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/HowbuyFund", tRootPath];
//    }
//    else if(kPathForStockUnSucessSendObject == type){
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/UnSucessSend",tRootPath];
//    }else if(kPathForSubjectFavorite == type){
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/favorite/",tRootPath];
//    }else if (kPathForPersonalCache == type){
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/personal/",tRootPath];
//    }else if (kPathForStudioCache == type){
//        NSString* tRootPath = [self getAppCachePath];
//        tFullPath = [NSString stringWithFormat:@"%@/studio/",tRootPath];
//    }
//    
//    else
//    {
//        NSAssert(NO, @"参数错误");
//    }
//    
//    if (tFullPath) {
//        if (![[NSFileManager defaultManager] fileExistsAtPath:tFullPath]) {
//            [[NSFileManager defaultManager] createDirectoryAtPath:tFullPath
//                                      withIntermediateDirectories:YES
//                                                       attributes:nil
//                                                            error:nil];
//        }
//    }
//    return tFullPath;
    
    return nil;
}

- (UIImage*) getBundleImage:(NSString*)imagePath
{
    if (imagePath == nil || imagePath.length == 0) {
        return nil;
    }
    UIImage* bundleImage = nil;
    
    @try {
        if([imagePath hasSuffix:@"@3x.png"])
        {
            bundleImage = [UIImage imageNamed:[imagePath stringByReplacingOccurrencesOfString:@"@3x.png" withString:@""]];
        }
        else if([imagePath hasSuffix:@"@2x.png"])
        {
            bundleImage = [UIImage imageNamed:[imagePath stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""]];
        }
        else if([imagePath hasSuffix:@".png"])
        {
            bundleImage = [UIImage imageNamed:[imagePath stringByReplacingOccurrencesOfString:@".png" withString:@""]];
        }
        else
        {
            bundleImage = [UIImage imageNamed:imagePath];
        }
    } @catch (NSException *exception) {
        bundleImage = nil;
    } @finally {
        return bundleImage;
    }
    
    return bundleImage;
    
    if (![imagePath hasSuffix:@"@3x.png"] && ![imagePath hasSuffix:@"@2x.png"]) {
        NSRange r = [imagePath rangeOfString:@".png"];
        if (r.location != NSNotFound) {
            if(isiPhone6Plus){
                imagePath =  [imagePath stringByReplacingCharactersInRange:r withString:@"@3x.png"];
            }else{
                imagePath =  [imagePath stringByReplacingCharactersInRange:r withString:@"@2x.png"];
            }
        }
    }
    
    NSString* path = [self getFullPath:imagePath pathtype:kPathForBundle];
    while(!path) {
        NSRange r;
        if([imagePath hasSuffix:@"@3x.png"]){
            r = [imagePath rangeOfString:@"@3x.png"];
            if (r.location != NSNotFound) {
                imagePath =  [imagePath stringByReplacingCharactersInRange:r withString:@"@2x.png"];
                path = [self getFullPath:imagePath pathtype:kPathForBundle];
            }
        }else if([imagePath hasSuffix:@"@2x.png"]){
            r = [imagePath rangeOfString:@"@2x.png"];
            if (r.location != NSNotFound) {
                imagePath =  [imagePath stringByReplacingCharactersInRange:r withString:@".png"];
                path = [self getFullPath:imagePath pathtype:kPathForBundle];
            }
        }else break;
    }
    
    if (path != nil)
    {
        bundleImage = [[UIImage alloc] initWithContentsOfFile:path] ;
    }
    
    return bundleImage;
}


+ (CGRect)deviceScreenBounds
{
    return [[UIScreen mainScreen] bounds];
}

+ (CGRect)applicationFrame
{
    return [[UIScreen mainScreen] applicationFrame];
}

- (NSString *)getCurrentVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)getReportInfor
{
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *appVersion = [self getCurrentVersion];
    return [NSString stringWithFormat:@"_plt=app&_appver=%@&_devId=%@&_app=ios",appVersion, deviceId];
}
@end
