//
//  CHJoinGroupParam.h
//  HTERP
//
//  Created by macbook on 23/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestParams.h"

@interface CHJoinGroupParam : CRequestBaseParams

@property (nonatomic, copy) NSString *userId;       //当前登录者

@end
