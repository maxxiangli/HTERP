//
//  CHCompanyInformation.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"

@protocol CHCompanyInformation
@end

@interface CHCompanyInformation : CJSONModel

@property(nonatomic, copy)NSString<Optional> *companyId;
@property(nonatomic, copy)NSString<Optional> *name;
@property(nonatomic, copy)NSString<Optional> *fullName;
@property(nonatomic, copy)NSString<Optional> *area;
@property(nonatomic, copy)NSString<Optional> *industry;
@property(nonatomic, copy)NSString<Optional> *uploadFiles;
@property(nonatomic, copy)NSString<Optional> *version;

@end
