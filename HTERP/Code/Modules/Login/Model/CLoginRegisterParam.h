//
//  CLoginRegisterParam.h
//  HTERP
//
//  Created by li xiang on 16/11/16.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CRequestParams.h"

@interface CLoginRegisterParam : CRequestBaseParams
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *passwd;
@property(nonatomic, copy) NSString *smscode;
@end
