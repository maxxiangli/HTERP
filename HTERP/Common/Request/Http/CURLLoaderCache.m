//
//  CURLLoaderCache.m
//  IOSLIB
//
//  Created by wang suning on 11-3-13.
//  Copyright 2011 tencent. All rights reserved.
//

#import "CURLLoaderCache.h"

#define kDefaultURLDataLoaderCount 20
@implementation CURLLoaderCache
@synthesize workedCache = _workedCache;
@synthesize freedCache = _freedCache;
@synthesize requestList = _requestList;


static CURLLoaderCache* _sharedLoaderCache = nil;
+ (CURLLoaderCache *) sharedLoaderCache
{
	if (!_sharedLoaderCache)
	{
		_sharedLoaderCache = [[CURLLoaderCache alloc] init];
	}
	return _sharedLoaderCache;
}

+ (id)alloc
{
	NSAssert(_sharedLoaderCache == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void) purgeSharedLoaderCache
{
	
	_sharedLoaderCache = nil;
}

- (id)init
{
    if ((self = [super init])) 
	{
		_scheduleTimer = nil;
		self.workedCache = [NSMutableArray arrayWithCapacity:kDefaultURLDataLoaderCount];
		self.freedCache = [NSMutableArray arrayWithCapacity:kDefaultURLDataLoaderCount];
		self.requestList = [NSMutableArray array];
		
		for (int i = 0; i < kDefaultURLDataLoaderCount; i ++)
		{
			[self.freedCache addObject:[CURLDataLoader urlDataLoader]];
		}
    }
    return self;
}

- (void) schedule
{
	if ([self.freedCache count] == 0 || [self.requestList count] == 0)
	{
        XLOGH(@"self.freedCache count: %lu", (unsigned long)[self.freedCache count]);
		return;
	}
	if (_scheduleTimer == nil || ![_scheduleTimer isValid])
	{
		
		_scheduleTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(notifyLoaderPrepared:) userInfo:nil repeats:NO];
	}
}

- (void) notifyLoaderPrepared:(id)param
{
	//会不会出错？
	//[_scheduleTimer invalidate];
	_scheduleTimer = nil;
	
    @autoreleasepool {
        NSObject<CURLDLoaderCacheDelegate>* d = nil;
        CURLDataLoader* l = nil;
        if ([self.freedCache count] > 0 && [self.requestList count] > 0)
        {
            d = [self.requestList objectAtIndex:0];
            l = [self.freedCache objectAtIndex:0];
            
            if (d != nil && l != nil)
            {
                [self.workedCache addObject:l];
                [self.freedCache removeObject:l];
                
                
                [self.requestList removeObject:d];
            }
        }
        
        [self schedule];
        
        if (d != nil && l != nil)
        {
            [d urlDataLoaderGetted:l];
            
        }
    }

	
	
}	

//- (CURLDataLoader*) newLoaderSync
//{
//	CURLDataLoader* l = nil;
//	if ([self.freedCache count] > 0)
//	{
//		l = [self.freedCache objectAtIndex:0];
//		[self.workedCache addObject:l];
//		[self.freedCache removeObject:l];
//	}
//	return l;
//}

- (void) newLoaderAsync:(NSObject<CURLDLoaderCacheDelegate>*)delegate
{
	NSAssert(delegate != nil, @"delegate 不能为空");
	
	[self.requestList addObject:delegate];
	[self schedule];
}

- (int) getFreedLoaderCount
{
	return (int)[self.freedCache count];
}

- (void) releaseLoader:(CURLDataLoader*)loader
{
	NSAssert(loader != nil, @"loader 一定不能为nil");
	if (loader != nil)
	{
		[loader cancelLoadData];
		[self.freedCache addObject:loader];
		[self.workedCache removeObject:loader];
		
		[self schedule];
	}
}

- (void)dealloc 
{
	self.workedCache = nil;
	self.freedCache = nil;
	self.requestList = nil;
	[_scheduleTimer invalidate];
	_scheduleTimer = nil;
	
    
}

@end
