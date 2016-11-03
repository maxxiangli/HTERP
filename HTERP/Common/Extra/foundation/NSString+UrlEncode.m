//
//  NSString+Helper.m
//  ShareTest
//
//  Created by cai lei on 12-9-26.
//
//

#import "NSString+UrlEncode.h"

@implementation NSString (URLEncode)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(
        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        (CFStringRef)self,
        NULL,
        CFSTR("!*'();:@&=+$,/?%#[]"),
        kCFStringEncodingUTF8));

    return result;
}

- (NSString *)stringByUTF8Escape
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByUTF8Unescape
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)isURL
{
    return [self hasPrefix:@"http://"];
}

- (NSURL *)url
{
    return [NSURL URLWithString:self];
}

- (NSURL *)url_s
{
    return [NSURL URLWithString:[self stringByUTF8Escape]];
}

+ (NSUInteger)unicodeLengthOfString:(NSString *)text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2)
    {
        unicodeLength++;
    }
    
    return unicodeLength;
}

@end
