//
//  CNetworkMonitor.m
//  QQStock
//
//  Created by suning wang on 12-2-15.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "CNetworkMonitor.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString *const kNetworkTypeNotificationKey = @"NETWORKTYPENOTIFICATIONKEY";

@interface CNetworkMonitor ()

@property (nonatomic,retain) Reachability* reachability;
@property (nonatomic,retain) CTTelephonyNetworkInfo * cellInfo;

@end

@implementation CNetworkMonitor
@synthesize networkType = _networkType;
@synthesize reachability = _reachability;

static CNetworkMonitor* _sharedNetworkMonitor = nil;
+ (CNetworkMonitor*) sharedNetworkMonitor
{
	if (_sharedNetworkMonitor == nil) {
		static dispatch_once_t sharedNetworkMonitorService;
		dispatch_once(&sharedNetworkMonitorService, ^{
			_sharedNetworkMonitor = [[CNetworkMonitor alloc] init];
		});
	}
	return _sharedNetworkMonitor;
}

+ (id)alloc
{
	NSAssert(_sharedNetworkMonitor == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void) purgeSharedNetworkMonitor
{
	
	_sharedNetworkMonitor = nil;
}

- (NSString *)getCellType
{
    if(nil == self.cellInfo)
    {
        self.cellInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    }
    if(nil == self.cellInfo)
    {
        return nil;
    }
    
    NSString * cell = self.cellInfo.currentRadioAccessTechnology;
    if(nil == cell)
    {
        return cell;
    }
    return [cell stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology" withString:@""];
}

- (id) init
{
	self = [super init];
	if (self)
	{
        _networkType = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if(isThaniOS6)
        {
            self.cellType = [self getCellType];
        }
		_reachability = nil;
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(reachabilityChanged:) 
													 name: kReachabilityChangedNotification 
												   object: nil];
        if(isThaniOS6)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cellNetworkUpdate:)
                                                     name:CTRadioAccessTechnologyDidChangeNotification
                                                   object:nil];
        }
	}
	return self;
}

- (void) cellNetworkUpdate:(NSNotification *)note
{
    self.cellType = [self getCellType];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.reachability = nil;
    self.cellType = nil;
    self.cellInfo = nil;
	
}

- (void) start
{
	if ([self isStarting])
	{
		return;
	}

	self.reachability = [Reachability reachabilityForInternetConnection];
	//[Reachability reachabilityWithHostName: @"www.baidu.com"];
	[self.reachability startNotifier];
}

- (void) start:(float)delay
{
	[self performSelector:@selector(start) withObject:nil afterDelay:delay];
}

- (BOOL) isStarting
{
	return self.reachability != nil;
}

- (void) stop
{
	[self.reachability stopNotifier];
	self.reachability = nil;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

	TNetworkType networkType = eNetworkNETNone;
	NetworkStatus reachableStatus = [curReach currentReachabilityStatus];
	switch (reachableStatus)
	{
		case NotReachable:
		{
			networkType = eNetworkNETNone;  
			break;
		}
		case ReachableViaWWAN:
		{
			networkType = eNetworkNETwwan;
			break;
		}
		case ReachableViaWiFi:
		{
			networkType = eNetworkNETwifi;
			break;
		}
		default:
			NSAssert(NO, @"未知Reachable");
			break;
	}
	
	if (_networkType != networkType)
	{
		XLOGH(@"current networkType: %ld", networkType);
		_networkType = networkType;
		[[NSNotificationCenter defaultCenter] postNotificationName:kNetworkTypeNotificationKey 
														object:[NSNumber numberWithInteger:_networkType]];
	}
}

@end
