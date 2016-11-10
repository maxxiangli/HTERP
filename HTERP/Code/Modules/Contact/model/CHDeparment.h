//
//  CHDeparment.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"
#import "CHUser.h"

@protocol CHDeparment

@end

@interface CHDeparment : CJSONModel

@property(nonatomic, strong)NSString<Optional> *deparmentId;
@property(nonatomic, strong)NSString<Optional> *rootId;
@property(nonatomic, strong)NSString<Optional> *name;
@property(nonatomic, strong)NSArray<CHDeparment,Optional> *deparments;
@property(nonatomic, strong)NSArray<CHUser,Optional> *users;

@end
