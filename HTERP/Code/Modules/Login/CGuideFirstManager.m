//
//  CGuideFirstManager.m
//  HTERP
//
//  Created by li xiang on 16/11/17.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CGuideFirstManager.h"

#define versionShowed       @"versionShowed"

@implementation CGuideFirstManager

- (BOOL)canShowFistView
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:versionShowed];
    //没保存过数据
    if ( ![dic isKindOfClass:[NSDictionary class]] )
    {
        return YES;
    }
    
    NSString *appVersion = [[CConfiguration sharedConfiguration] getCurrentVersion];
    NSString *version = [dic objectForKey:appVersion];
    //该版本已经展示过引导页
    if ( [version isEqualToString:@"1"] )
    {
        return NO;
    }
    
    return YES;
}

//已经显示了引导页
- (void)showedFirstView
{
    NSString *appVersion = [[CConfiguration sharedConfiguration] getCurrentVersion];
    NSDictionary *dic = @{appVersion : @"1"};
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:versionShowed];
}

+ (CGuideFirstManager *)getInstance
{
    static CGuideFirstManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CGuideFirstManager alloc] init];
    });
    
    return manager;
}
@end
