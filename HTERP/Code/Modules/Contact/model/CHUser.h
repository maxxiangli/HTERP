//
//  CHUserMode.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"

@protocol CHUser
@end

@interface CHUser : CJSONModel

@property(nonatomic, strong)NSString<Optional> *userId;
@property(nonatomic, strong)NSString<Optional> *name;
@property(nonatomic, strong)NSString<Optional> *mobile;
@property(nonatomic, strong)NSString<Optional> *companyId;
@property(nonatomic, strong)NSString<Optional> *branchId;
@property(nonatomic, strong)NSString<Optional> *email;
@property(nonatomic, strong)NSString<Optional> *phone;
@property(nonatomic, strong)NSString<Optional> *status;
@property(nonatomic, strong)NSString<Optional> *nickname;
@property(nonatomic, strong)NSString<Optional> *imgurl;

@end
