//
//  CImageHelper.m
//  QQStock
//
//  Created by suning wang on 11-10-31.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import "CImageHelper.h"

@implementation CImageHelper

+ (UIImage*) getImage:(CGSize)imageSize withColor:(UIColor*)color
{
	NSAssert(color != nil, @"参数错误");
	
	UIImage* image = nil;
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	}
	else 
	{
		UIGraphicsBeginImageContext(imageSize);
	}
	[color set];
	UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage*) getImage:(CGSize)imageSize bgColor:(UIColor*)bgColor withText:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont lineBreakMode:(NSLineBreakMode)breakMode alignment:(NSTextAlignment)alignment edgeInsets:(UIEdgeInsets)edgeInsets
{
	NSAssert(text != nil, @"参数错误");
	NSAssert(textColor != nil, @"参数错误");
	NSAssert(textFont != nil, @"参数错误");
	
	UIImage* image = nil;
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	}
	else 
	{
		UIGraphicsBeginImageContext(imageSize);
	}
	
	CGRect bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
	if (bgColor != nil)
	{
		[bgColor set];
		UIRectFill(bounds);
	}
	
	[textColor set];
	[text drawInRect:CGRectMake(edgeInsets.left, edgeInsets.top, bounds.size.width - edgeInsets.left - edgeInsets.right, bounds.size.height - edgeInsets.top - edgeInsets.bottom) withFont:textFont lineBreakMode:breakMode alignment:alignment color:textColor];
	
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage*) getImage:(CGSize)imageSize l:(NSString*)lImageName c:(NSString*)cImageName r:(NSString*)rImageName edgeInsets:(UIEdgeInsets)edgeInsets
{
	NSAssert(lImageName != nil, @"参数错误");
	NSAssert(cImageName != nil, @"参数错误");
	NSAssert(rImageName != nil, @"参数错误");
	
	UIImage* lImage = BUNDLEIMAGE(lImageName);
	UIImage* cImage = BUNDLEIMAGE(cImageName);
	UIImage* rImage = BUNDLEIMAGE(rImageName);
	
	UIImage* image = nil;
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	}
	else 
	{
		UIGraphicsBeginImageContext(imageSize);
	}

	float h = imageSize.height - edgeInsets.top - edgeInsets.bottom;
	[lImage drawInRect:CGRectMake(edgeInsets.left, edgeInsets.top, lImage.size.width, h)];
	[cImage drawInRect:CGRectMake(lImage.size.width + edgeInsets.left, edgeInsets.top, (imageSize.width - lImage.size.width - rImage.size.width - edgeInsets.left - edgeInsets.right), h)];
	[rImage drawInRect:CGRectMake(imageSize.width - rImage.size.width - edgeInsets.right, edgeInsets.top, rImage.size.width, h)];

	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage*) scaleImage:(CGSize)maxSize srcImage:(UIImage*)srcImage
{
	NSAssert(srcImage != nil, @"参数错误");
	
	CGSize srcImageSize = srcImage.size;
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		srcImageSize.width = srcImageSize.width * srcImage.scale;
		srcImageSize.height = srcImageSize.height * srcImage.scale;
	}
	
	if (srcImageSize.width <= maxSize.width && srcImageSize.height <= maxSize.height)
	{
		return srcImage;
	}
	
	float fw = maxSize.width / srcImageSize.width;
	float fh = maxSize.height / srcImageSize.height;
	float f = fw;
	
	if (fw > fh)
	{
		f = fh;
	}
	CGSize imageSize = CGSizeMake(srcImageSize.width * f, srcImageSize.height * f);
	
	UIImage* image = nil;
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.0f);
	}
	else 
	{
		UIGraphicsBeginImageContext(imageSize);
	}
	[srcImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

//缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
	CGSize imageSize =  CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize);
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	}
	else
	{
		UIGraphicsBeginImageContext(imageSize);
	}
	
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//剪裁
//+ (UIImage*)cutImage:(UIImage *)image toSize:(CGRect)rect
//{
//	CGSize cupImageSize = CGSizeMake(rect.size.width, rect.size.height);
//	if (NULL != UIGraphicsBeginImageContextWithOptions)
//		UIGraphicsBeginImageContextWithOptions(cupImageSize, NO, [UIScreen mainScreen].scale);
//	else
//		UIGraphicsBeginImageContext(cupImageSize);
//	
//	[image drawInRect:rect];
//	
//    UIImage *cupImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//	
//    return cupImage;
//}

//剪裁
+ (UIImage*)cutImage:(UIImage *)image toSize:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return smallImage;
}


+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets image:(UIImage*)srcImage
{
	UIImage *image = nil;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
    {
        image = [srcImage stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    else
    {
        image = [srcImage resizableImageWithCapInsets:capInsets];
    }
    
    return image;
}

+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode image:(UIImage *)srcImage
{
    UIImage *image = nil;

    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)
    {
        image = [srcImage stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    else
    {
        image = [srcImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    }
    
    return image;
}

+ (void) beginImage:(CGSize)imageSize
{
	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0)
	{
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	}
	else
	{
		UIGraphicsBeginImageContext(imageSize);
	}
}

+ (void) beginImage:(CGSize)imageSize useScale:(float)scale
{
	NSAssert([[UIDevice currentDevice].systemVersion doubleValue] >= 4.0, @"该函数必须在IOS4以上调用");
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
}

+ (UIImage*) commitImage
{
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+(UIImage*) joinImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage
{
	CGSize size = CGSizeMake(leftImage.size.width+rightImage.size.width, MAX(leftImage.size.height,rightImage.size.height));
	
//	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//	else
//		UIGraphicsBeginImageContext(size);
    
	[leftImage  drawInRect:CGRectMake(0, 0, leftImage.size.width, size.height)];
	[rightImage drawInRect:CGRectMake(leftImage.size.width, 0, rightImage.size.width, size.height)];
	
	UIImage *joinImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return joinImage;
}

+(UIImage*) joinImage:(UIImage*)topImage bottom:(UIImage*)bottomImage
{
	CGSize size = CGSizeMake(MAX(bottomImage.size.width, topImage.size.width), topImage.size.height + bottomImage.size.height);
//	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//	else
//		UIGraphicsBeginImageContext(size);
	
	[topImage drawInRect:CGRectMake(0, 0, size.width, topImage.size.height)];
	[bottomImage drawInRect:CGRectMake(0, topImage.size.height, size.width, bottomImage.size.height)];
	
	UIImage *joinImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return joinImage;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
{
//	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(reSize, NO, [UIScreen mainScreen].scale);
//	else
//		UIGraphicsBeginImageContext(reSize);
	
//	UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
	
	[image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
	UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return reSizeImage;
	
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return img;
}

@end
