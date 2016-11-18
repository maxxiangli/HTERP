//
//  CHUserMode.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"
#import "CHItem.h"

@protocol CHUser
@end

@interface CHUser : CHItem

//@property(nonatomic, copy)NSString<Optional> *userId;
//@property(nonatomic, copy)NSString<Optional> *name;
@property(nonatomic, copy)NSString<Optional> *mobile;
@property(nonatomic, copy)NSString<Optional> *companyId;
@property(nonatomic, copy)NSString<Optional> *branchId;
@property(nonatomic, copy)NSString<Optional> *email;
@property(nonatomic, copy)NSString<Optional> *phone;
@property(nonatomic, copy)NSString<Optional> *status;
@property(nonatomic, copy)NSString<Optional> *nickname;
@property(nonatomic, copy)NSString<Optional> *imgurl;
@property(nonatomic, copy)NSString<Optional> *sex;

@end
