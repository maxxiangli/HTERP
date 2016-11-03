//
//  CURLLoaderCache.h
//  IOSLIB
//
//  Created by wang suning on 11-3-13.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CURLDataLoader.h"

@protocol CURLDLoaderCacheDelegate <CURLDataLoaderDelegate>

@required
- (void) urlDataLoaderGetted:(CURLDataLoader*)dataLoader;

@end

//URLDataLoader缓存，控制在系统中最多同时存在的数量
@interface CURLLoaderCache : NSObject
{
	NSMutableArray* _workedCache;
	NSMutableArray* _freedCache;
	NSMutableArray* _requestList;
	
	NSTimer* _scheduleTimer;
}

@property (nonatomic,retain) NSMutableArray* workedCache;
@property (nonatomic,retain) NSMutableArray* freedCache;
@property (nonatomic,retain) NSMutableArray* requestList;

+ (CURLLoaderCache *) sharedLoaderCache;
+ (void) purgeSharedLoaderCache;

- (void) newLoaderAsync:(NSObject<CURLDLoaderCacheDelegate>*)delegate;
- (void) releaseLoader:(CURLDataLoader*)loader;
//- (CURLDataLoader*) newLoaderSync;
- (int) getFreedLoaderCount;

@end
