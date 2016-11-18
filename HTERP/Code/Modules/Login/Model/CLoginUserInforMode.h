//
//  CLoginUserInforMode.h
//  HTERP
//
//  Created by macbook on 18/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CRequestJSONModelBase.h"

@protocol CLoginUserInforMode

@end

@interface CLoginUserInforMode : JSONModel

@property(nonatomic, copy) NSString<Optional> *name;
@property(nonatomic, copy) NSString<Optional> *sex;
@property(nonatomic, copy) NSString<Optional> *imgurl;



@end
