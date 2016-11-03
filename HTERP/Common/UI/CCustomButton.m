//
//  CCustomButton.m
//  QQStock
//
//  Created by sony on 12-6-27.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "CCustomButton.h"

#define kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN     12.0f
#define kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN    12.0f
#define kUIVIEWCONTROLLER_BUTTON_TOPMARGIN      5.0f
#define kUIVIEWCONTROLLER_BUTTON_BOTTOMMARGIN   5.0f

@interface _CCustomButton ()
{
    eCustomButtonStyle _buttonStyle;
}
- (void)setTitle:(NSString *)titleStr style:(eCustomButtonStyle)style;
@end

@implementation _CCustomButton

+ (id)buttonWithTitle:(NSString *)title style:(eCustomButtonStyle)style
{
    _CCustomButton * button = [_CCustomButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title style:style];
    return button;
}

+ (UIImage *)stretchImg:(UIImage *)img vertical:(float)offset
{
    UIImage *image = nil;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
    {
        image = [img stretchableImageWithLeftCapWidth:0 topCapHeight:offset];
    }
    else
    {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(offset, 0, [img size].height - offset - 10, 0);
        image = [img resizableImageWithCapInsets:capInsets];
    }
    
    return image;
}

- (UIImage*) imageWithStyle:(eCustomButtonStyle)buttonStyle forState:(UIControlState)state
{
    UIImage *img = nil;
    UIEdgeInsets capInsets;
    
	switch (buttonStyle)
	{
 		case eCustomButtonStyleLeftAngle:
		{
            if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"leftAngleBtn_bg_normal.png");
                    img = [img stretchableImageWithLeftCapWidth:13 topCapHeight:4];//图片左右边有通透10个像素
                } 
                else if (UIControlStateHighlighted == state) 
                {
                    img = BUNDLEIMAGE(@"leftAngleBtn_bg_hlt.png");
                    img = [img stretchableImageWithLeftCapWidth:13 topCapHeight:4];
                } 
            }
            else 
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"leftAngleBtn_bg_normal.png");
                    capInsets = UIEdgeInsetsMake(0, 13, img.size.height, 7);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
                else if (UIControlStateHighlighted == state)
                {
                    img = BUNDLEIMAGE(@"leftAngleBtn_bg_hlt.png");
                    capInsets = UIEdgeInsetsMake(0, 13, img.size.height, 7);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
            }
		}
			break;           
            
		case eCustomButtonStyleSquare:
		{
            if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_normal.png");
                    img = [img stretchableImageWithLeftCapWidth:3 topCapHeight:4];
                } 
                else if (UIControlStateHighlighted == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_hlt.png");
                    img = [img stretchableImageWithLeftCapWidth:3 topCapHeight:4];
                } 
            }
            else 
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_normal.png");
                    capInsets = UIEdgeInsetsMake(0, 3, img.size.height, 3);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
                else if (UIControlStateHighlighted == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_hlt.png");
                    capInsets = UIEdgeInsetsMake(0, 3, img.size.height, 3);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
            }
		}
			break;
			
		case eCustomButtonStyleRedSquare:
		{
            if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"squareBlueBtn_bg_normal.png");
                    img = [img stretchableImageWithLeftCapWidth:3 topCapHeight:4];
                } 
                else if (UIControlStateHighlighted == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_hlt.png");
                    img = [img stretchableImageWithLeftCapWidth:3 topCapHeight:4];
                } 
            }
            else 
            {
                if (UIControlStateNormal == state) 
                {
                    img = BUNDLEIMAGE(@"squareBlueBtn_bg_normal.png");
                    capInsets = UIEdgeInsetsMake(0, 3, img.size.height, 3);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
                else if (UIControlStateHighlighted == state) 
                {
                    img = BUNDLEIMAGE(@"squareBtn_bg_hlt.png");
                    capInsets = UIEdgeInsetsMake(0, 3, img.size.height, 3);
                    img = [img resizableImageWithCapInsets:capInsets];
                } 
            }
		}
			break;
			
		default:
			break;
	}
	return img;
}

- (void)setTitle:(NSString *)titleStr style:(eCustomButtonStyle)style
{
    NSAssert(titleStr != nil, @"title不能为空");
    
    _buttonStyle = style;
    UIFont* textFont = [UIFont boldSystemFontOfSize:13];
    CGSize textSize = [titleStr sizeWithFont:textFont];
    float width = kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN + textSize.width + kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN;

    UIEdgeInsets titleEdge;
    
    if (eCustomButtonStyleLeftAngle == style) 
    {
        width += 6;//因为左箭头，所以title居中不美观，这里多拉伸6个像素。
        titleEdge = UIEdgeInsetsMake(kUIVIEWCONTROLLER_BUTTON_TOPMARGIN, kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN + 6, kUIVIEWCONTROLLER_BUTTON_BOTTOMMARGIN, kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN);
    }
    else
    {
        titleEdge = UIEdgeInsetsMake(kUIVIEWCONTROLLER_BUTTON_TOPMARGIN, kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN, kUIVIEWCONTROLLER_BUTTON_BOTTOMMARGIN, kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN);
    }
    
    CGRect frame = CGRectMake(0, 0, width, 31);//31不能修改，因为不规则的图片不能被纵向拉伸
    [self setTitleEdgeInsets:titleEdge];
    self.frame = frame;
    
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self.titleLabel setFont:textFont];
    
    [self changeTheme];
}

- (void)dealloc
{
    
}

- (void)changeTheme
{
    UIImage* backgroundImage = [self imageWithStyle:_buttonStyle forState:UIControlStateNormal];
    NSAssert(backgroundImage != nil, @"逻辑错误");
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];

//modify by maxxiangli at 20130327 for button的选中状态使用系统效果
//    backgroundImage = [self imageWithStyle:_buttonStyle forState:UIControlStateHighlighted];
//    if (backgroundImage) 
//    {
//        [self setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
//    }
    
    switch (_buttonStyle) {
        case eCustomButtonStyleSquare:
        case eCustomButtonStyleLeftAngle:
            [self setTitleColor:TC_CustomButtonTitleColorForNormalStyle forState:UIControlStateNormal];
            [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case eCustomButtonStyleRedSquare:
            [self setTitleColor:TC_CustomButtonTitleColorForRedStyle forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    /*
    if (self.tag == 999972) {
        XLOGF(@"set me to %@", hidden?@"TRUE":@"FALSE");
    }
     */
}
@end


@interface CCustomButton ()
{
    eCustomButtonStyle _buttonStyle;
}
@property (nonatomic) eCustomButtonStyle buttonStyle;
@end

@implementation CCustomButton
@synthesize buttonStyle = _buttonStyle;

+ (id)buttonWithTitle:(NSString *)title style:(eCustomButtonStyle)style
{
    CCustomButton * button = nil;
    if(eCustomButtonStyleLeftAngle == style)
    {
        button = [CCustomButton buttonWithType:UIButtonTypeCustom];
    }
    else if(eCustomButtonStyleRedSquare == style)
    {
        button = [CCustomButton buttonWithType:((isThaniOS6)?UIButtonTypeSystem:UIButtonTypeCustom)];
        [button setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        button = [CCustomButton buttonWithType:((isThaniOS6)?UIButtonTypeSystem:UIButtonTypeCustom)];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    button.buttonStyle = style;
    [button setBackgroundColor:[UIColor clearColor]];
    [button changeTheme];
    
    CGFloat width = 0;
    if(eCustomButtonStyleLeftAngle == style)
    {
        width = 22;
    }
    else
    {
        UIFont* textFont = [UIFont boldSystemFontOfSize:FS_CustomButton_Default];
        if(button && button.titleLabel && [button.titleLabel respondsToSelector:@selector(setFont:)])
        {
            [[button titleLabel] setFont:textFont];
        }
        CGSize textSize = [title sizeWithFont:textFont];
        width = kUIVIEWCONTROLLER_BUTTON_LEFTMARGIN + textSize.width + kUIVIEWCONTROLLER_BUTTON_RIGHTMARGIN;
        width = textSize.width;
    }
    button.frame = CGRectMake(0, 0, width, 44);

    return button;
}

+ (UIImage *)stretchImg:(UIImage *)img vertical:(float)offset
{
    UIImage *image = nil;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
    {
        image = [img stretchableImageWithLeftCapWidth:0 topCapHeight:offset];
    }
    else
    {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(offset, 0, [img size].height - offset - 10, 0);
        image = [img resizableImageWithCapInsets:capInsets];
    }
    
    return image;
}

+ (UIImage *)stretchImgHorizontal:(UIImage *)img horizontal:(float)offset
{
	UIImage *image = nil;
	
	if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
	{
		image = [img stretchableImageWithLeftCapWidth:offset topCapHeight:0];
	}
	else
	{
		UIEdgeInsets capInsets = UIEdgeInsetsMake(0, offset, 0, offset);
        image = [img resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
	}
	
	return image;
}

+ (UIImage *)clipImage:(UIImage*)img InRect:(CGRect)rect
{
    if(!img) return img;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, img.scale);
    [img drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchImgHEdge:(UIImage *)img left:(CGFloat)left newLeft:(CGFloat)newLeft right:(CGFloat)right newRight:(CGFloat)newRight
{
    if(!img) return img;
    if(left < 1) left = 1;
    if(newLeft < 1) newLeft = 1;
    if(right < 1) right = 1;
    if(newRight < 1) newRight = 1;
    CGSize size = img.size;
    size.width += newLeft - left + newRight - right;
    UIGraphicsBeginImageContextWithOptions(size, NO, img.scale);
    // 绘制
    // 左
    UIImage *p = [CCustomButton clipImage:img InRect:CGRectMake(0, 0, left, size.height)];
    [p drawInRect:CGRectMake(0, 0, newLeft, size.height)];
    // 右
    p = [CCustomButton clipImage:img InRect:CGRectMake(img.size.width - right, 0, right, size.height)];
    [p drawInRect:CGRectMake(size.width - newRight, 0, newRight, size.height)];
    // 中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, CGRectMake(newLeft, 0, img.size.width - left - right, size.height));
    [img drawAtPoint:CGPointMake(newLeft - left, 0)];
    // 提取
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchImgVEdge:(UIImage *)img top:(CGFloat)top newTop:(CGFloat)newTop bottom:(CGFloat)bottom newBottom:(CGFloat)newBottom
{
    if(!img) return img;
    if(top < 1) top = 1;
    if(newTop < 1) newTop = 1;
    if(bottom < 1) bottom = 1;
    if(newBottom < 1) newBottom = 1;
    CGSize size = img.size;
    size.height += newTop - top + newBottom - bottom;
    UIGraphicsBeginImageContextWithOptions(size, NO, img.scale);
    // 绘制
    // 上
    UIImage *p = [CCustomButton clipImage:img InRect:CGRectMake(0, 0, size.width, newTop)];
    [p drawInRect:CGRectMake(0, 0, size.width, top)];
    // 下
    p = [CCustomButton clipImage:img InRect:CGRectMake(0, img.size.height - bottom, size.width, bottom)];
    [p drawInRect:CGRectMake(0, size.height - newBottom, size.width, newBottom)];
    // 中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, CGRectMake(0, newTop - top, size.width, img.size.height - top - bottom));
    [img drawAtPoint:CGPointMake(0, newTop - top)];
    // 提取
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchImgHPos:(UIImage *)img xPos:(CGFloat)xPos width:(CGFloat)width
{
    if(!img) return img;
    if(xPos < 0 || xPos > img.size.width) return nil;
    if(width < 1) width = 1;
    CGSize size = img.size;
    size.width += width - 1;
    UIGraphicsBeginImageContextWithOptions(size, NO, img.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 左
    if(xPos >= 1){
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(0, 0, xPos, img.size.height));
        [img drawAtPoint:CGPointMake(0, 0)];
        CGContextRestoreGState(ctx);
    }
    // 右
    if(xPos <= img.size.width - 1){
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(xPos + width, 0, img.size.width - xPos - 1, img.size.height));
        [img drawAtPoint:CGPointMake(width, 0)];
        CGContextRestoreGState(ctx);
    }
    // 中
    UIImage *p = [CCustomButton clipImage:img InRect:CGRectMake(xPos, 0, 1, img.size.height)];
    [p drawInRect:CGRectMake(xPos, 0, width, img.size.height)];
    // 提取
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchImgVPos:(UIImage *)img yPos:(CGFloat)yPos height:(CGFloat)height
{
    if(!img) return img;
    if(yPos < 0 || yPos > img.size.height) return nil;
    if(height < 1) height = 1;
    CGSize size = img.size;
    size.height += height - 1;
    UIGraphicsBeginImageContextWithOptions(size, NO, img.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 上
    if(yPos >= 1){
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(0, 0, img.size.width, yPos));
        [img drawAtPoint:CGPointMake(0, 0)];
        CGContextRestoreGState(ctx);
    }
    // 下
    if(yPos <= img.size.height - 1){
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(0, yPos + height, img.size.width, img.size.height - yPos - 1));
        [img drawAtPoint:CGPointMake(0, height)];
        CGContextRestoreGState(ctx);
    }
    // 中
    UIImage *p = [CCustomButton clipImage:img InRect:CGRectMake(0, yPos, img.size.width, 1)];
    [p drawInRect:CGRectMake(0, yPos, img.size.width, height)];
    // 提取
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)changeTheme
{
    if(eCustomButtonStyleLeftAngle == _buttonStyle)
    {
        [self setImage:BUNDLEIMAGE(@"stock_navigation_back.png") forState:UIControlStateNormal];
        [self setImage:BUNDLEIMAGE(@"stock_navigation_back_down.png") forState:UIControlStateHighlighted];
    }
    else if(eCustomButtonStyleRedSquare == _buttonStyle)
    {
        [self setTitleColor:TC_CustomButtonTitleColorForRedStyle forState:UIControlStateNormal];
        if(NO == (isThaniOS6))
        {
            [self setTitleColor:[TC_CustomButtonTitleColorForRedStyle colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        [self setTitleColor:TC_CustomButtonTitleColorForNormalStyle forState:UIControlStateNormal];
        if(NO == (isThaniOS6))
        {
            [self setTitleColor:[TC_CustomButtonTitleColorForNormalStyle colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        }
    }
}

@end

