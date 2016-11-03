//
//  NSString+Draw.m
//  QQStock
//
//  Created by sony on 15/11/18.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "NSString+Draw.h"

@implementation NSString (Draw)
- (CGSize)sizeWithFont:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self sizeWithAttributes:attributes];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    //NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    return retSize;
}

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment linSpacing:(CGFloat)space
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineSpacing = space;
    NSDictionary *attributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    return retSize;
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color
{
    if(nil == font)
    {
        font = [UIFont systemFontOfSize:0.1];
    }
    
    if(nil == color)
    {
        color = [UIColor redColor];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:paragraphStyle};
    
    [self drawInRect:rect withAttributes:attributes];
    
    
    return rect.size;
}

- (CGSize)drawInRect:(CGRect)rect withFontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color minimumScale:(CGFloat)scale
{
    if(nil == color)
    {
        color = [UIColor redColor];
    }
    if(fontSize <= 0) fontSize = 1;
    CGFloat minimumFont = fontSize * scale;
    CGFloat midSize = fontSize;
    
    while(1){
        if(minimumFont >= fontSize) break;
        midSize = (minimumFont + fontSize) / 2;
        CGFloat fontWidth = [self sizeWithFont:[UIFont systemFontOfSize:midSize]].width;
        if(fontWidth < rect.size.width - 5){
            minimumFont = midSize + 0.5;
        }else{
            fontSize = midSize - 0.5;
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:paragraphStyle};
    
    [self drawInRect:rect withAttributes:attributes];
    
    
    return rect.size;
}

- (CGSize)_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    return [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment color:[UIColor redColor]];
}

- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font color:(UIColor *)color
{
    if(nil == font)
    {
        font = [UIFont systemFontOfSize:0.1];
    }
    
    if(nil == color)
    {
        color = [UIColor redColor];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    [self drawInRect:rect withAttributes:attributes];
    
    return rect.size;
}

- (CGSize)_drawInRect:(CGRect)rect withFont:(UIFont *)font
{
    return [self drawInRect:rect withFont:font color:[UIColor redColor]];
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment color:(UIColor *)color
{
    return [self drawInRect:CGRectMake(point.x, point.y, width, CGFLOAT_MAX) withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentJustified color:color];
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode color:(UIColor *)color
{
    return [self drawInRect:CGRectMake(point.x, point.y, width, CGFLOAT_MAX) withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentJustified color:color];
}

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font color:(UIColor *)color
{
    if(nil == font)
    {
        font = [UIFont systemFontOfSize:0.1];
    }
    
    if(nil == color)
    {
        color = [UIColor redColor];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    [self drawAtPoint:point withAttributes:attributes];
    
    return CGSizeMake(0, 0);
}

@end
