//
//  CLoginLoginParam.h
//  HTERP
//
//  Created by li xiang on 2016/11/10.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CRequestParams.h"

@interface CLoginLoginParam : CRequestBaseParams
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *passwd;
@property(nonatomic, assign) NSInteger checktype;
@property(nonatomic, copy) NSString *smscode;
@end
