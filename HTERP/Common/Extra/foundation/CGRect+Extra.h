//
//  CGRect+Extra.h
//  Paper
//
//  Created by pre-team on 14-2-24.
//  Copyright (c) 2014年 pre-team. All rights reserved.
//

void CGRectSplit(const CGRect rect,
    CGFloat rect1Height,
    CGRect *result1,
    CGRect *result2);

CGRect CGRectAjustTop(const CGRect rect, CGFloat top);

CGRect CGRectAliginBottom(CGRect source, CGRect target);

#define RECT_Left(rect)                   (CGRectGetMinX(rect))
#define RECT_Top(rect)                    (CGRectGetMinY(rect))

#define RECT_Right(rect)                  (CGRectGetMaxX(rect))
#define RECT_Bottom(rect)                 (CGRectGetMaxY(rect))

#define RECT_Width(rect)                  (CGRectGetWidth(rect))
#define RECT_Height(rect)                 (CGRectGetHeight(rect))

#define RECT_AjustTop(rect, offset)       CGRectAjustTop(rect, offset)
#define RECT_Shrink(rect, w, h)           CGRectInset(rect, w, h)
#define RECT_AliginBottom(source, target) CGRectAliginBottom(source, target)

#define kAnchorLeft   0
#define kAnchorTop    1
#define kAnchorWidth  2
#define kAnchorHeight 3

CGRect CGRectSetValue(CGRect source, CGFloat value, NSInteger anchor);

#define RECT_SET_LEFT(rect, value)   CGRectSetValue(rect, value, kAnchorLeft)
#define RECT_SET_TOP(rect, value)    CGRectSetValue(rect, value, kAnchorTop)
#define RECT_SET_WIDTH(rect, value)  CGRectSetValue(rect, value, kAnchorWidth)
#define RECT_SET_HEIGHT(rect, value) CGRectSetValue(rect, value, kAnchorHeight)

CGRect CGRectAjustValue(CGRect source, CGFloat value, NSInteger anchor);

#define RECT_AJUST_LEFT(rect, value)   CGRectAjustValue(rect, value, kAnchorLeft)
#define RECT_AJUST_TOP(rect, value)    CGRectAjustValue(rect, value, kAnchorTop)
#define RECT_AJUST_WIDTH(rect, value)  CGRectAjustValue(rect, value, kAnchorWidth)
#define RECT_AJUST_HEIGHT(rect, value) CGRectAjustValue(rect, value, kAnchorHeight)

CGRect CGRectCrop(CGRect source, CGFloat width, CGFloat height);

#define RECT_CROP(rect, w, h) CGRectCrop(rect, w, h)
