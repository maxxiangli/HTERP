//
//  CHSearchContactMode.h
//  HTERP
//
//  Created by macbook on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHUser.h"

@interface CHSearchContactMode : NSObject

@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, strong) CHUser *user;

@end
