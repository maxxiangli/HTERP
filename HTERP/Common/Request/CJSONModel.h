//
//  CCJSONModel.h
//  QQStock
//
//  Created by zheliang on 14/12/2.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "JSONModel.h"


@interface CJSONModel : JSONModel
/**
 *  解析完model后，允许用户根据数据自定义操作
 */
- (void)configModel;
@end
