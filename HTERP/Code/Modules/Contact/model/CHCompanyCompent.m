//
//  CHCompanyGroup.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHCompanyCompent.h"

@implementation CHCompanyCompent

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.itemType = [NSNumber numberWithInteger:CHContactCompanyCompent];
    }
    
    return self;
}

@end
