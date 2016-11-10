//
//  CHCompanyGroup.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"
#import "CHCompanyInformation.h"
#import "CHDeparment.h"

@protocol CHCompanyCompent

@end

@interface CHCompanyCompent : CJSONModel

@property(nonatomic, strong)CHCompanyInformation<Optional> *companyInfo;
@property(nonatomic, strong)NSArray<CHDeparment, Optional> *branchList;
@property(nonatomic, strong)NSArray<CHUser, Optional> *users;

@end
