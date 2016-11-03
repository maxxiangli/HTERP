//
//  CURLDataDownloader.h
//  QQStock
//
//  Created by suning wang on 12-7-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CURLDataLoader.h"

@interface CURLDataDownloader : CURLDataLoader
{
}

@property (nonatomic,copy) NSString* localPath;

@end
