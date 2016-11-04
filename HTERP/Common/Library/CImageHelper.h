//
//  CImageHelper.h
//  QQStock
//
//  Created by suning wang on 11-10-31.
//  Copyright (c) 2011年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CImageHelper : NSObject
{
}

+ (UIImage*) getImage:(CGSize)imageSize withColor:(UIColor*)color;
+ (UIImage*) getImage:(CGSize)imageSize l:(NSString*)lImageName c:(NSString*)cImageName r:(NSString*)rImageName edgeInsets:(UIEdgeInsets)edgeInsets;
//按尺寸缩放
+ (UIImage*) scaleImage:(CGSize)maxSize srcImage:(UIImage*)srcImage;
//按比例缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
//按区域剪裁
+ (UIImage*)cutImage:(UIImage *)image toSize:(CGRect)rect;

+ (UIImage*) getImage:(CGSize)imageSize bgColor:(UIColor*)bgColor withText:(NSString*)text textColor:(UIColor*)textColor textFont:(UIFont*)textFont lineBreakMode:(NSLineBreakMode)breakMode alignment:(NSTextAlignment)alignment edgeInsets:(UIEdgeInsets)edgeInsets;

+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets image:(UIImage*)srcImage;
+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode image:(UIImage *)srcImage;

+ (void) beginImage:(CGSize)imageSize;
+ (void) beginImage:(CGSize)imageSize useScale:(float)scale;
+ (UIImage*) commitImage;
+ (UIImage*) joinImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage;
+ (UIImage*) joinImage:(UIImage*)topImage bottom:(UIImage*)bottomImage;


+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage *) imageWithView:(UIView *)view;



@end
