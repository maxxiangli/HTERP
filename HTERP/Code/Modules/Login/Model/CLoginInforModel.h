//
//  CLoginInforModel.h
//  HTERP
//
//  Created by li xiang on 2016/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CRequestJSONModelBase.h"

//登录成功，后台返回的数据
@interface CLoginInforModel : CRequestJSONModelBase
@property(nonatomic, copy) NSString *userId;//后台返回
@property(nonatomic, copy) NSString *session;//后台返回

@property(nonatomic, copy) NSString<Optional> *uin;

//数据有效性（例如：缺少session）
- (BOOL)dataIsValid;
@end
