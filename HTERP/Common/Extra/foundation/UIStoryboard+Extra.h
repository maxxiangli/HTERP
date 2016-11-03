//
//  UIStoryboard+Extra.h
//  HomeService
//
//  Created by pre-team on 14-5-6.
//  Copyright (c) 2014年 pre-team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Extra)
- (id)controllerWithID:(NSString *)identifier;
- (id)initialController;
@end
