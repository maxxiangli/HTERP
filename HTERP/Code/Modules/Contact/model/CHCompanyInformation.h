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

@property(nonatomic, strong)NSString<Optional> *companyId;
@property(nonatomic, strong)NSString<Optional> *name;
@property(nonatomic, strong)NSString<Optional> *fullName;
@property(nonatomic, strong)NSString<Optional> *area;
@property(nonatomic, strong)NSString<Optional> *industry;
@property(nonatomic, strong)NSString<Optional> *uploadFiles;
@property(nonatomic, strong)NSString<Optional> *version;

@end
