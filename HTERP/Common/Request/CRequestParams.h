//
//  CRequestParams.h
//  QQStock
//
//  Created by zheliang on 15/2/3.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRequestParams <NSObject>
+ (NSString*)path;
+ (NSString*)serverAddress;
- (NSString*)paramString;
- (NSDictionary*)paramDictionary;
- (id)valueForKey:(id)key;
@optional
/*更新用户名等动态数据*/
- (void)updateDynamicValue;
+ (NSString*)stringDescriptionForObject:(id)object;
/**
 *  自动生成请求参数时忽略类变量
 *
 *  @param propertyName 类变量名称
 *
 *  @return 当return YES时 propertyName对应的类变量将不加入请求参数，反之则假如请求参数.
 */
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end

/**
 *  请求共用参数
 *  uin 用户识别号 qq号或微信
 *  qs_id 券商代码，详见数据字典
 *  注意: 派生类需要注意serverAddress
 *  注意: 派生类请求时的参数直接定义成类变量
 *  注意: 派生类必须实现path方法
 *  注意: 如果派生类中的类变量不希望加入到请求参数中，请重载+(BOOL)propertyIsIgnored:(NSString*)propertyName;当propertyName与不希望假如请求参数的变量明 return YES;
 
 */
@interface CRequestBaseParams : NSObject <CRequestParams>
@property (assign, nonatomic) NSInteger tag;//标记请求用
- (NSString*)paramString;
- (NSDictionary*)paramDictionary;
@end

@interface CRequest : NSObject
/**
 *  生成get请求拼接参数后的URL
 *
 *  @param params 请求参数实例，每个请求应派生CRequestBaseParams
 *
 *  @return 生成的URL
 */
+ ( NSString*)generatorGetRequestURLWithParams:(CRequestBaseParams*)params;

/**
 *  生成请求的URL 不拼接参数
 *
 *  @param params 请求参数实例，每个请求应派生CRequestBaseParams
 *
 *  @return 请求的URL(不拼接参数)
 */
+ ( NSString*)generatorRequestURL:(CRequestBaseParams*)params;


@end




