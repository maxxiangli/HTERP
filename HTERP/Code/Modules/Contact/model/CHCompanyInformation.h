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

@property(nonatomic, strong)NSString *companyId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *fullName;
@property(nonatomic, strong)NSString *area;
@property(nonatomic, strong)NSString *industry;
@property(nonatomic, strong)NSString *uploadFiles;
@property(nonatomic, strong)NSString *version;

@end
