//
//  CHItem.h
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONModel.h"

//Rainbow colors
typedef NS_ENUM(NSInteger, CHContactType)
{
    CHContactUser = 0, //用户
    CHContactDepartment = 1, //部门
    CHContactCompanyInfo  = 3,  //公司信息
    CHContactCompanyCompent = 4 //公司包括人员和部门
};

@protocol CHItem
@end

@interface CHItem : JSONModel

@property(nonatomic, strong)NSNumber<Ignore> *contactType;

//用户 部门 公司 Id
@property(nonatomic, copy)NSString<Optional> *itemId;

//用户 部门 公司 名称
@property(nonatomic, copy)NSString<Optional> *itemName;



@end
