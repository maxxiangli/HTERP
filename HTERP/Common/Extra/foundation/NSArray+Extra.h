//
// NSArray+Extra.h
// IntelligentHome
//
// Created by zheliang on 周日 2013-11-10.
// Copyright (c) 2013年 zheliang. All rights reserved.
//

#import <Foundation/Foundation.h>
NSInteger sortByFirstObjectComparator(NSArray* uno, NSArray* dos, void* context) ;

@interface NSArray (Ext)
/**
 *  解决PHP后台字典无数据时,默认返回空数组,程序对空数组调用字典的方法时崩溃
 *
 *  @return 空数组
 */
- (NSArray*)allKeys;
/**
 *  解决PHP后台字典无数据时,默认返回空数组,程序对空数组调用字典的方法时崩溃
 *
 *  @return 空数组
 */
- (NSArray*)allValue;
/**
 *  解决PHP后台字典无数据时,默认返回空数组,程序对空数组调用字典的方法时崩溃
 *
 *  @return nil
 */
- (id)objectForKey:(NSString *)key;

-(BOOL) include:(id)obj ;
-(NSArray*) slice:(int)loc :(int)length_ ;
-(NSArray*) slice:(int)loc backward:(int)backward ;
-(id) second ;
-(id) third ;
-(NSArray*) append:(NSArray*)ary ;
-(NSArray*) sort ;
@end


@interface NSArray (CapitalizedExt)

-(NSString*) Join:(NSString*)sep ;
-(id) First ;
-(id) Last ;
-(NSArray*) Reverse ;
@end


@interface NSMutableArray (Ext)
-(void) clear ;
@end

@interface NSArray (Extra)
- (id)at:(NSInteger)index;
- (id)objectAtIndex_s:(NSUInteger)index;
- (id)randomObject;
- (NSString*)join:(NSString*)separator;

- (id)head;
- (id)tail;


/**
 *  对数组中的每一个元素执行processor
 *   index 元素在数组中的索引
 *   element 元素本身
 *   array 数组本身
 *   continuous 对数组的访问是否继续,默认为YES
 */

- (instancetype)foreach:( void (^)(NSUInteger index, id element, id array, BOOL*continuous) )processor;
- (instancetype)foreach_s:( void (^)(id object, BOOL*continuous) )processor;

- (NSArray*)filter:( BOOL (^)(NSUInteger index, id element, NSArray*array) )processor;
- (NSArray*)filter_s:( BOOL (^)(id element) )processor;
- (NSArray*)collect:( id (^)(NSUInteger index, id element, NSArray*array) )processor;
- (NSArray*)collect_s:( id (^)(id element) )processor;
@end

extern const CGRect       RECT_GUARD;
extern const CGPoint      POINT_GUARD;
extern const CGSize       SIZE_GUARD;
extern const CGFloat      FLOAT_GUARD;
extern const NSInteger    INTEGER_GUARD;
extern const NSInteger    UINTEGER_GUARD;

@interface NSArray ( VAArguemnts )
+ (NSArray*)arrayWithRects:(NSInteger)numberOfItems, ...;
+ (NSArray*)arrayWithPoints:(NSInteger)numberOfItems, ...;
+ (NSArray*)arrayWithSizes:(NSInteger)numberOfItems, ...;
+ (NSArray*)arrayWithFloats:(NSInteger)numberOfItems, ...;
+ (NSArray*)arrayWithIntegers:(NSInteger)numberOfItems, ...;
+ (NSArray*)arrayWithUIntegers:(NSUInteger)numberOfItems, ...;

// 自动转换角度为弧度
+ (NSArray*)arrayWithDegrees:(NSInteger)numberOfItems, ...;
@end

#define MACROCAT( x, y ) MACROCAT1(x, y)
#define MACROCAT1( x, y ) x##y
#define TOSTRING( s ) #s

#define NUMBER_OF_ARGS(...) PP_NARG_( __VA_ARGS__, PP_RSEQ_N() )
#define PP_NARG_(...) PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N( \
        _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, N, ...) N
#define PP_RSEQ_N() \
    16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

// #define SPREAD0( arg ) #arg
// #define SPREAD1(arg, ...) SPREAD0(arg)
// #define SPREAD2(arg, ...) SPREAD0(arg) SPREAD1(__VA_ARGS__,)
// #define SPREAD3(arg, ...) SPREAD0(arg) SPREAD2(__VA_ARGS__,)
// #define SPREAD4(arg, ...) SPREAD0(arg) SPREAD3(__VA_ARGS__,)
// #define SPREAD5(arg, ...) SPREAD0(arg) SPREAD4(__VA_ARGS__,)
// #define SPREAD6(arg, ...) SPREAD0(arg) SPREAD5(__VA_ARGS__,)
// #define SPREAD7(arg, ...) SPREAD0(arg) SPREAD6(__VA_ARGS__,)
// #define SPREAD8(arg, ...) SPREAD0(arg) SPREAD7(__VA_ARGS__,)
// #define SPREAD9(arg, ...) SPREAD0(arg) SPREAD8(__VA_ARGS__,)
// #define SPREAD(...) SPREAD9(__VA_ARGS__)

#define DECVAL_1 0
#define DECVAL_2 1
#define DECVAL_3 2
#define DECVAL_4 3
#define DECVAL_5 4
#define DECVAL_6 5
#define DECVAL_7 6
#define DECVAL_8 7
#define DECVAL_9 8
#define DECVAL( n ) DECVAL_##n



#define NUMBER_OF_ARGS(...) PP_NARG_( __VA_ARGS__, PP_RSEQ_N() )
#define PP_NARG_(...) PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N( \
        _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, N, ...) N
#define PP_RSEQ_N() \
    16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

#define _R(M, n, arg, ...) MACROCAT(M, 0) (arg), MACROCAT( M, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)

#define DOBULE_ARRAY0(arg) ( (double)(arg) )
#define DOBULE_ARRAY1(n, arg, ...)  DOBULE_ARRAY0(arg)
#define DOBULE_ARRAY2(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY3(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY4(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY5(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY6(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY7(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY8(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)
#define DOBULE_ARRAY9(n, arg, ...)  DOBULE_ARRAY0(arg), MACROCAT( DOBULE_ARRAY, DECVAL(n) ) (DECVAL(n), __VA_ARGS__)

#define DOBULE_ARRAY(...) MACROCAT( DOBULE_ARRAY, NUMBER_OF_ARGS(__VA_ARGS__) ) (NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__)

#define RECT_ARRAY(...)   [NSArray arrayWithRects : NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__]
#define POINT_ARRAY(...)  [NSArray arrayWithPoints : NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__]
#define SIZE_ARRAY(...)   [NSArray arrayWithSizes : NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__]
#define FLOAT_ARRAY(...)  [NSArray arrayWithFloats : NUMBER_OF_ARGS(__VA_ARGS__), DOBULE_ARRAY(__VA_ARGS__)]
#define INT_ARRAY(...)    [NSArray arrayWithIntegers : NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__]
#define UINT_ARRAY(...)   [NSArray arrayWithUIntegers : NUMBER_OF_ARGS(__VA_ARGS__), __VA_ARGS__]
#define DEGREE_ARRAY(...) [NSArray arrayWithDegrees : NUMBER_OF_ARGS(__VA_ARGS__), DOBULE_ARRAY(__VA_ARGS__)]

@interface NSMutableArray (Extra)
- (void)random;
- (void)moveItemAt:(NSUInteger)sourceIndex toIndex:(NSUInteger)targetIndex;
- (void)addObject_s:(id)object;
- (void)insertObject_s:(id)object atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex_s:(NSUInteger)index;

- (void)push:(id)object;
- (id)pop;
@end

@interface NSArray (CAKeyframeAnimation)
- (NSArray*)keyTimes;
- (CGFloat)sum;
@end
