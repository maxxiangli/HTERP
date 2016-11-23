//
//  CHGroupUserList.h
//  HTERP
//
//  Created by macbook on 23/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestJSONModelBase.h"
#import "CHIMUserModel.h"

@interface CHGroupUserList : CRequestJSONModelBase

@property (nonatomic, strong) NSArray<CHIMUserModel, Optional> *users;

@end
