//
//  CCustomUILabel.m
//  QQStock_lixiang
//
//  Created by xiang li on 13-9-16.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "CCustomUILabel.h"

@interface CCustomUILabel()

@property(nonatomic, assign) CGFloat* theFontSize;
@property(nonatomic, assign) BOOL isFontBold;
@property(nonatomic, retain) NSString* originText;

@end

static CGFloat defaultFontSize = 0.f;

@implementation CCustomUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setTheFontSize:&defaultFontSize];

//		//[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(onFontSizeChanged:)
//													 name:kNoteStockChangeFontTypeFor6p
//												   object:nil];
		
    }
    return self;
}

- (void) dealloc {
    Safe_Release(_originText);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

- (void) onFontSizeChanged:(NSNotification*) notify {
	CGFloat size = *self.theFontSize;
	if (size == defaultFontSize) return;
	
	UIFont *font;
	if (self.isFontBold) {
		font = [UIFont boldSystemFontOfSize:size];
	} else {
		font = [UIFont systemFontOfSize:size];
	}
	[self setFont:font];
	[self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    if ([text isEqualToString:self.originText]) {
        return;
    }
    self.originText = text;
    if ( [[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0f )
    {
        [super setText:text];
        return;
    }
    
    if ( self.minimumScaleFactor >= 1 )
    {
        [super setText:text];
        return;
    }
    
    UIFont *font = self.font;
    //font = [font fontWithSize:self.minimumFontSize];
    //modify by maxxiangli for 最小字体超过frame显示问题 on 2015.12.7
    font = [font fontWithSize:self.minimumScaleFactor * self.font.pointSize];
    CGSize size = [text sizeWithFont:font];
    
    //逻辑：计算最小字号是否超宽，如果超宽，累加字符算宽度
    if ( YES == self.adjustsFontSizeToFitWidth && size.width > self.frame.size.width )
    {
        NSString *tempText = nil;
        CGSize tempSize;
        
        for ( int i = 1; i < [text length]; i++ )
        {
            
            tempText = [text substringToIndex:i];
            tempSize = [tempText sizeWithFont:font];
            
            if ( tempSize.width >= self.frame.size.width )
            {
                tempText = [text substringToIndex:i - 1];
                break;
            }
        }
        
        [super setText:tempText];
    }
    else
    {
        [super setText:text];
    }
}

/**初始化一个lable
 *
 */
+ (CCustomUILabel *)labelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold opaque:(BOOL)opaque
{
    UIFont *font;
    if (bold)
    {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else
    {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
	CCustomUILabel *newLabel = [[CCustomUILabel alloc] initWithFrame:CGRectZero] ;
    
    if (opaque == NO)
    {
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.opaque = NO;
    }
    else
    {
        newLabel.backgroundColor = TC_DefaultBackgroundColor;
        newLabel.opaque = YES;
    }
    
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
    
	return newLabel;
}

+ (CCustomUILabel *)labelWithPrimaryColor1:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat*)fontSize bold:(BOOL)bold opaque:(BOOL)opaque {

	CCustomUILabel *newLabel = [[CCustomUILabel alloc] initWithFrame:CGRectZero] ;
	newLabel.theFontSize = fontSize;
	newLabel.isFontBold = bold;
	
	CGFloat size = *newLabel.theFontSize;
	
	UIFont *font;
	if (bold)
	{
		font = [UIFont boldSystemFontOfSize:size];
	}
	else
	{
		font = [UIFont systemFontOfSize:size];
	}
	
	
	if (opaque == NO)
	{
		newLabel.backgroundColor = [UIColor clearColor];
		newLabel.opaque = NO;
	}
	else
	{
		newLabel.backgroundColor = TC_DefaultBackgroundColor;
		newLabel.opaque = YES;
	}
	
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}


@end
