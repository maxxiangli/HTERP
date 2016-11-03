//
//  CCustomButton.h
//  QQStock
//
//  Created by sony on 12-6-27.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
	eCustomButtonStyleLeftAngle,
	eCustomButtonStyleSquare,
	eCustomButtonStyleRedSquare
}eCustomButtonStyle;

@interface _CCustomButton : UIButton
+(id)buttonWithTitle:(NSString *)title style:(eCustomButtonStyle)style;
- (void)changeTheme;

//图片纵向拉伸
+ (UIImage *)stretchImg:(UIImage *)img vertical:(float)offset;
@end

@interface CCustomButton : UIButton
+(id)buttonWithTitle:(NSString *)title style:(eCustomButtonStyle)style;
- (void)changeTheme;

//图片纵向拉伸
+ (UIImage *)clipImage:(UIImage*)image InRect:(CGRect)rect;
+ (UIImage *)stretchImg:(UIImage *)img vertical:(float)offset;
+ (UIImage *)stretchImgHorizontal:(UIImage *)img horizontal:(float)offset;
// 左右边界拉伸，宽度left->newLeft，right->newRight
+ (UIImage *)stretchImgHEdge:(UIImage *)img left:(CGFloat)left newLeft:(CGFloat)newLeft right:(CGFloat)right newRight:(CGFloat)newRight;
// 上下边界拉伸，宽度top->newTop，bottom->newBottom
+ (UIImage *)stretchImgVEdge:(UIImage *)img top:(CGFloat)top newTop:(CGFloat)newTop bottom:(CGFloat)bottom newBottom:(CGFloat)newBottom;
// 横向单列（1px）拉伸，拉伸到宽度width
+ (UIImage *)stretchImgHPos:(UIImage *)img xPos:(CGFloat)xPos width:(CGFloat)width;
// 纵向单行（1px）拉伸，拉伸到高度height
+ (UIImage *)stretchImgVPos:(UIImage *)img yPos:(CGFloat)yPos height:(CGFloat)height;
@end
