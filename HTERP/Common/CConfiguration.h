//
//  HTConfiguration.h
//  HTERP
//
//  Created by li xiang on 16/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CThemeManager.h"

#define BUNDLEIMAGE(path) ([[CThemeManager sharedThemeManager] getBundleImageUnderTheme:path])
#define BUNDLEIMAGE_C(path) ([[CThemeManager sharedThemeManager] getBundleImageUnderTheme:path])
#define THEMECOLOR(name) ([[CThemeManager sharedThemeManager] getColorUnderTheme:name])

typedef enum
{
    kPathForDocument = 0,
    kPathForCache,
    kPathForImageCache,
    kPathForBundle,
    kPathForFileCache,
    kPathForDBCache,
    kPathForNewsCache,
    kPathForPdfCache,
    kPathForStockDataCache,//个股详情页数据目录
    kPathForSmartBoxCache,//smartBox目录
    kPathForTradingCache,//交易目录
    kPathForCommunityCache,//股票圈
    kPathForStockCommentCache,//个股评论
    kPathForHowbuyFundCache,//好买基金
    kPathForStockUnSucessSendObject,
    
    kPathForSubjectFavorite,  //股票评论收藏
    
    kPathForHuShenTradeCache,//沪深交易目录
    kPathForPersonalCache,//沪深交易目录
    kPathForStudioCache,//直播间目录
    
    
}TPathType;

typedef enum
{
    eThemeBlackWhite = 0,
    eThemeBlueWhite,
}
TThemeType;

typedef enum
{
    eFontTypeFor6pBig = 0,
    eFontTypeFor6pNormal = 1,
}TFontTypeFor6p;

@interface CConfiguration : NSObject
@property (nonatomic, assign)		TThemeType			themeType;//换肤
@property (nonatomic, assign)       TFontTypeFor6p      fontTypeFor6p;//6p字体设置，默认为0，大字体

+ (CConfiguration*) sharedConfiguration;

- (NSString*) getPathByType:(TPathType)type;
- (UIImage*) getBundleImage:(NSString*)imagePath;


+ (CGRect)deviceScreenBounds;
+ (CGRect)applicationFrame;

- (NSString *)getCurrentVersion;
- (NSString *)getReportInfor;

@end
