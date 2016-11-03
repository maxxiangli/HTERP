//
//  NSString+FirstCharacter.m
//  QQStock
//
//  Created by michaelxing on 15/12/9.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "NSString+FirstCharacter.h"

@implementation NSString (FirstCharacter)

- (BOOL)firstCharacterIsAlpha
{
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];

    if (length > 0)
    {
        if([[NSCharacterSet letterCharacterSet] characterIsMember:charBuffer[0]])
        {
            return YES;
        }
    }
    return NO;
}

@end
