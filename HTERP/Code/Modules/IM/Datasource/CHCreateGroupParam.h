//
//  CHCreateGroupParam.h
//  HTERP
//
//  Created by macbook on 22/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestParams.h"

@interface CHCreateGroupParam : CRequestBaseParams

@property (nonatomic, copy) NSString *userId;       //当前登录者

@end
