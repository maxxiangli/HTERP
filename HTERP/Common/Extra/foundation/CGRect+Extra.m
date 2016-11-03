//
//  CGRect+Extra.m
//  Paper
//
//  Created by pre-team on 14-2-24.
//  Copyright (c) 2014年 pre-team. All rights reserved.
//

#import "CGRect+Extra.h"

void CGRectSplit(const CGRect rect, CGFloat rect1Height, CGRect *result1, CGRect *result2)
{
    *result1 = rect;
    (*result1).size.height = rect1Height;

    *result2 = rect;

    (*result2).size.height = CGRectGetHeight(rect) - rect1Height;
    (*result2).origin.y    = CGRectGetMaxY(rect) - (*result2).size.height;
}

CGRect CGRectAjustTop(const CGRect rect, CGFloat top)
{
    CGRect ret = rect;

    ret.origin.y += top;
    return ret;
}

CGRect CGRectAliginBottom(CGRect source, CGRect target)
{
    CGRect result = source;

    result.origin.y = RECT_Bottom(target) - RECT_Height(source);
    return result;
}

CGRect CGRectSetValue(CGRect source, CGFloat value, NSInteger anchor)
{
    CGRect result = source;

    if (anchor == kAnchorTop)
    {
        result.origin.y = value;
    }
    else if (anchor == kAnchorLeft)
    {
        result.origin.x = value;
    }
    else if (anchor == kAnchorHeight)
    {
        result.size.height = value;
    }
    else if (anchor == kAnchorWidth)
    {
        result.size.width = value;
    }
    else
    {
        Warning(@"invalid anchor");
    }

    return result;
}

CGRect CGRectAjustValue(CGRect source, CGFloat value, NSInteger anchor)
{
    CGRect result = source;

    if (anchor == kAnchorTop)
    {
        result.origin.y += value;
    }
    else if (anchor == kAnchorLeft)
    {
        result.origin.x += value;
    }
    else if (anchor == kAnchorHeight)
    {
        result.size.height += value;
    }
    else if (anchor == kAnchorWidth)
    {
        result.size.width += value;
    }
    else
    {
        Warning(@"invalid anchor");
    }

    return result;
}

CGRect CGRectCrop(CGRect source, CGFloat width, CGFloat height)
{
    CGRect result = source;

    result.size.width  = width;
    result.size.height = height;
    return result;
}
