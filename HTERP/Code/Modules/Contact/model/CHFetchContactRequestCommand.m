//
//  CHFetchContactRequestCommand.m
//  HTERP
//
//  Created by macbook on 15/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHContactList.h"
#import "CHContactList+sort.h"

#import "CHFetchContactRequestCommand.h"

@implementation CHFetchContactRequestCommand

- (BOOL) urlDataLoadAuthentication:(CURLDataLoader*)loader
                       trustServer:(NSString*)host
{
    return NO;
}

-(void)parserDataInThread:(NSData *)recvData
{
    NSError *error = nil;
    self.responseModel = [[self.modelClass alloc] initWithData:recvData
                                                         error:&error];
    
    if ([self.responseModel isKindOfClass:[CHContactList class]])
    {
        CHContactList *list = (CHContactList *)self.responseModel;
        [list prepareForSort];
    }
}


@end
