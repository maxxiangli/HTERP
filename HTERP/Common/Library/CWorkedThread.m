//
//  CWorkedThread.m
//  QQStock
//
//  Created by suning wang on 11-11-21.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import "CWorkedThread.h"

typedef struct {
  WrokerthreadId thread_id;
  const char* thread_name;
  __unsafe_unretained  CWorkedThread* thread_object;
} ThreadIdNameMap;



@interface CThreadParam : NSObject
{
}

@property (retain) id target;
@property (assign) SEL selector;
@property (retain) id argument;
@property (assign) float delay;

- (void) reset;

@end


@implementation CThreadParam
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize argument = _argument;
@synthesize delay = _delay;

- (id) init
{
  self = [super init];
  if (self)
  {
    [self reset];
  }
  return self;
}

- (void) reset
{
  self.target = nil;
  self.selector = nil;
  self.argument = nil;
  self.delay = 0.0f;
}

- (void) dealloc
{
  [self reset];
  
}

@end


@interface CWorkedThread ()

@property (retain) NSThread* workedThread;
@property (retain) NSRecursiveLock *cancelledLock;
@property (nonatomic,assign) BOOL isWorking;
@property (nonatomic, copy) NSString* threadName;

@end

@implementation CWorkedThread
@synthesize workedThread = _workedThread;
@synthesize cancelledLock = _cancelledLock;
@synthesize isWorking = _isWorking;
@synthesize threadName = _threadName;

static ThreadIdNameMap g_thread_id_name_map[] = {
  {kIOThread, "IOThread", nil},
  {kFileThread, "FileThread", nil},
};

static BOOL g_threads_inited = NO;

+ (CWorkedThread *) sharedWorkedThread
{
  if (!g_thread_id_name_map[kIOThread].thread_object)
  {
    CWorkedThread* workerThread = [[CWorkedThread alloc] init];
    workerThread.threadName = [NSString stringWithUTF8String:g_thread_id_name_map[kIOThread].thread_name];
    g_thread_id_name_map[kIOThread].thread_object = workerThread;
    [workerThread start];
  }

  if (!g_thread_id_name_map[kFileThread].thread_object)
  {
    CWorkedThread* workerThread = [[CWorkedThread alloc] init];
    workerThread.threadName = [NSString stringWithUTF8String:g_thread_id_name_map[kFileThread].thread_name];
    g_thread_id_name_map[kFileThread].thread_object = workerThread;
    [workerThread start];
  }

  g_threads_inited = YES;

  return g_thread_id_name_map[kIOThread].thread_object;
}

+ (BOOL)currentlyOn:(WrokerthreadId)threadId {
  NSAssert(threadId < kThreadTypeCount && threadId >= kIOThread, @"参数错误");
  NSThread* currentThread = [NSThread currentThread];
  NSString* currentThreadName = [currentThread name];
  return strcmp([currentThreadName UTF8String], g_thread_id_name_map[threadId].thread_name) == 0;
}

+ (id)alloc
{
  NSAssert(!g_threads_inited,
      @"Attempted to allocate a second instance of a singleton.");
  return [super alloc];
}

+ (void) purgeSharedWorkedThread
{
  [g_thread_id_name_map[kIOThread].thread_object cancel];
  
  g_thread_id_name_map[kIOThread].thread_object = nil;

  [g_thread_id_name_map[kFileThread].thread_object cancel];
  
  g_thread_id_name_map[kFileThread].thread_object = nil;
}

- (id) init
{
  self = [super init];
  if (self)
  {
    self.workedThread = nil;
    self.cancelledLock = [[NSRecursiveLock alloc] init] ;
    self.isWorking = NO;
  }
  return self;
}

- (void) start
{
  XLOG(@"start start");
  if (self.workedThread == nil)
  {
    XLOG(@"start start start");
    self.isWorking = YES;
    NSThread* workedThread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequests) object:nil];
    [workedThread setName:self.threadName];
    [workedThread start];
    self.workedThread = workedThread;
    
  }
  XLOG(@"start end");
}

- (void) runRequests
{
  XLOG(@"run request start");
  // Should keep the runloop from exiting
  CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
  CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
  CFRunLoopRef runLoop = CFRunLoopGetCurrent();
  CFRunLoopAddSource(runLoop, source, kCFRunLoopDefaultMode);
  
  while (self.isWorking)
  {
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      @autoreleasepool {
          CFRunLoopRun();

      }
//    [pool drain];
  }
  
  // Should never be called, but anyway
  CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
  CFRelease(source);
  XLOG(@"run request end");
}

- (BOOL) isWorked
{
  BOOL result;
    
  [[self cancelledLock] lock];
    result = self.isWorking;
    [[self cancelledLock] unlock];
    
    return result;
}

- (void)cancelOnRequestThread
{
  XLOG(@"cancelOnRequestThread start");
  [[self cancelledLock] lock];
  
    if (!self.isWorking)
  {
    [[self cancelledLock] unlock];
    return;
  }

  CFRetain((__bridge CFTypeRef)(self));
    self.isWorking = NO;
  [[self cancelledLock] unlock];
  CFRelease((__bridge CFTypeRef)(self));
  XLOG(@"cancelOnRequestThread end");
}

- (void) cancel
{
  XLOG(@"cancel start");
  if (self.workedThread != nil)
  {
    XLOG(@"cancel start start");
    [self performSelector:@selector(cancelOnRequestThread) onThread:self.workedThread withObject:nil waitUntilDone:NO];
    [self.workedThread cancel];
    self.workedThread = nil;
  }
  XLOG(@"cancel end");
}

- (void) performTargetSync:(id)target selector:(SEL)aSelector withObject:anArgument
{
  NSAssert(target != nil && aSelector != nil, @"参数错误");
  NSAssert(self.workedThread != nil, @"使用错误，请先调用start");
  [target performSelector:aSelector onThread:self.workedThread withObject:anArgument waitUntilDone:YES];
  
  XLOG(@"performTargetSync:selector:withObject:");
}

- (void) performTarget:(id)target selector:(SEL)aSelector withObject:anArgument
{
  NSAssert(target != nil && aSelector != nil, @"参数错误");
  NSAssert(self.workedThread != nil, @"使用错误，请先调用start");
  
  CThreadParam* param = [[CThreadParam alloc] init] ;
  param.target = target;
  param.selector = aSelector;
  param.argument = anArgument;
  param.delay = -1.0f;
//#warning for 测试
//  [self performSelector:@selector(timeSelectorOnThread:) withObject:param afterDelay:0.0f];
  [self performSelector:@selector(timeSelectorOnThread:) onThread:self.workedThread withObject:param waitUntilDone:NO];
  
  XLOG(@"performTarget:selector:withObject:");
}

- (void) performTarget:(id)target
              selector:(SEL)aSelector
            withObject:anArgument
              inThread:(WrokerthreadId)threadId {
  NSAssert(threadId < kThreadTypeCount && threadId >= kIOThread, @"参数错误");
  CWorkedThread* workerThread = g_thread_id_name_map[threadId].thread_object;
  [workerThread performTarget:target selector:aSelector withObject:anArgument];
}

- (void) performTarget:(id)target selector:(SEL)aSelector withObject:anArgument afterDelay:(float)delay
{
  NSAssert(target != nil && aSelector != nil && delay >= 0.0f, @"参数错误");
  NSAssert(self.workedThread != nil, @"使用错误，请先调用start");
  
  CThreadParam* param = [[CThreadParam alloc] init] ;
  param.target = target;
  param.selector = aSelector;
  param.argument = anArgument;
  param.delay = delay;
  [self performSelector:@selector(timeSelectorOnThread:) onThread:self.workedThread withObject:param waitUntilDone:NO];
  
  XLOG(@"performTarget:selector:withObject:afterDelay:");
}

- (void) timeSelectorOnThread:(CThreadParam*)param
{
  XLOG(@"timeSelectorOnThread start");
  if (param.delay >= 0.0f)
  {
      if (param.target && param.selector && [param.target respondsToSelector:param.selector]) {
          SuppressPerformSelectorLeakWarning(
                                             [param.target performSelector:param.selector withObject:param.argument afterDelay:param.delay];
                                             );
      }
  }
  else 
  {
      if (param.target && param.selector && [param.target respondsToSelector:param.selector]) {
          SuppressPerformSelectorLeakWarning(
                                             [param.target performSelector:param.selector withObject:param.argument];
                                             );
      }
  }
  XLOG(@"timeSelectorOnThread end");
}

- (void) dealloc
{
  [self cancel];
  self.cancelledLock = nil;
  
}

@end
