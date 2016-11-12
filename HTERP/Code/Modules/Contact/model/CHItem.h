//
//  CHItem.h
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONModel.h"

@protocol CHItem
@end

@interface CHItem : JSONModel

@property(nonatomic, strong)NSNumber<Ignore> *type;

//用户 部门 公司 Id
@property(nonatomic, copy)NSString<Optional> *itemId;

//用户 部门 公司 名称
@property(nonatomic, copy)NSString<Optional> *itemName;



@end
