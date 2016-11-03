//
//  CWorkedThread.h
//  QQStock
//
//  Created by suning wang on 11-11-21.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kIOThread,
  kFileThread,
  kThreadTypeCount
} WrokerthreadId;

@interface CWorkedThread : NSObject
{
}

+ (CWorkedThread *) sharedWorkedThread;
+ (void) purgeSharedWorkedThread;
+ (BOOL) currentlyOn:(WrokerthreadId)threadId;

//线程控制函数
- (void) start;
- (BOOL) isWorked;
- (void) cancel;

//线程操作函数
- (void) performTargetSync:(id)target selector:(SEL)aSelector withObject:anArgument;
- (void) performTarget:(id)target selector:(SEL)aSelector withObject:anArgument;
- (void) performTarget:(id)target selector:(SEL)aSelector withObject:anArgument afterDelay:(float)delay;

- (void) performTarget:(id)target selector:(SEL)aSelector withObject:anArgument inThread:(WrokerthreadId)threadId;

@end
