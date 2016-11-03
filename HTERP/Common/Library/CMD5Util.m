//
//  CMD5Util.m
//  QQStock
//
//  Created by 王苏宁 on 11-5-19.
//  Copyright 2011年 tencent. All rights reserved.
//

#import "CMD5Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CMD5Util

+ (NSString*) md5String:(NSString*)srcString
{
	if (srcString == nil || ![srcString isKindOfClass:[NSString class]])
	{
		return nil;
	}
	const char *cStr = [srcString UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			]; 
}

@end
