//
//  CStopWatch.h
//  QQStock
//
//  Created by 王苏宁 on 11-9-10.
//  Copyright 2011年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/time.h>

//profile，用来测试某段代码消耗的时长
@interface CStopWatch : NSObject
{
	struct timeval tv1, tv2;
}

//全局唯一
+ (CStopWatch*) stopwatch;
- (void) startWatch;
- (void) startWatch:(NSString*)message;
//输出message以及消耗时间
- (void) lap:(NSString*)message;
//获取stopwatch消耗时间
- (double) getRunningTime;

@end

#if (DEBUG_LOGF != 0)
#	define STOCKWATCH 1
#else
#	define STOCKWATCH 0
#endif

#if (STOCKWATCH != 0)
#  define INIT_STOPWATCH(s) CStopWatch *s = [CStopWatch stopwatch]
#  define LAP(s, msg) [s lap:msg]
#else
#  define INIT_STOPWATCH(s)
#  define LAP(s, msg) 
#endif
