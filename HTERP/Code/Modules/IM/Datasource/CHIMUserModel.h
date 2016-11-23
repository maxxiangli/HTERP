//
//  CHIMUserModel.h
//  HTERP
//
//  Created by macbook on 23/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestJSONModelBase.h"

@protocol CHIMUserModel
@end

@interface CHIMUserModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *imageurl;
@property (nonatomic, copy) NSString<Optional> *sex;

@end
