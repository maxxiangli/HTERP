//
//  NSString+Helper.h
//  ShareTest
//
//  Created by cai lei on 12-9-26.
//
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *)URLEncodedString;
- (NSString *)stringByUTF8Escape;
- (NSString *)stringByUTF8Unescape;

- (BOOL)isURL;
- (NSURL *)url;
- (NSURL *)url_s;

+ (NSUInteger)unicodeLengthOfString:(NSString *)text;

@end
