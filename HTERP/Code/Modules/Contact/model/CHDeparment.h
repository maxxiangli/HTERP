//
//  CHDeparment.h
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CJSONModel.h"
#import "CHUser.h"
#import "CHItem.h"

@protocol CHDeparment

@end

@interface CHDeparment : CHItem //CJSONModel

//@property(nonatomic, copy)NSString<Optional> *deparmentId;
@property(nonatomic, copy)NSString<Optional> *rootId;
//@property(nonatomic, copy)NSString<Optional> *name;
@property(nonatomic, strong)NSArray<CHDeparment,Optional> *deparments;
@property(nonatomic, strong)NSArray<CHUser,Optional> *users;

@end
