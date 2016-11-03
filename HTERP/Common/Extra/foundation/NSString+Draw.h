//
//  NSString+Draw.h
//  QQStock
//
//  Created by sony on 15/11/18.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Draw)
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment linSpacing:(CGFloat)space;

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color;
- (CGSize)_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color;
- (CGSize)_drawInRect:(CGRect)rect withFont:(UIFont *)font;

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment color:(UIColor *)color;
- (CGSize)drawInRect:(CGRect)rect withFontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color minimumScale:(CGFloat)scale;
- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode color:(UIColor *)color;

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font color:(UIColor *)color;
@end
