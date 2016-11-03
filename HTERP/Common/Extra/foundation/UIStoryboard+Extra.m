//
//  UIStoryboard+Extra.m
//  HomeService
//
//  Created by pre-team on 14-5-6.
//  Copyright (c) 2014年 pre-team. All rights reserved.
//

#import "UIStoryboard+Extra.h"

@implementation UIStoryboard (Extra)
- (id)controllerWithID:(NSString *)identifier
{
    return [self instantiateViewControllerWithIdentifier:identifier];
}

- (id)initialController
{
    return [self instantiateInitialViewController];
}

@end
