//
//  CAppThemeManager.m
//  QQStock
//
//  Created by ZHANG Tianle on 4/5/12.
//  Copyright (c) 2012 tencent. All rights reserved.
//

#import "CThemeManager.h"
#import "UIColor+Extra.h"
@interface CThemeManager()

@property (nonatomic, retain) NSMutableDictionary* blackWhiteColorDic;
@property (nonatomic, retain) NSMutableDictionary* blueWhiteColorDic;

-(void) loadThemeColorDic:(NSString*)dicName colorDic:(NSMutableDictionary*)colorDic;

@end

@implementation CThemeManager

@synthesize blackWhiteColorDic = _blackWhiteColorDic;
@synthesize blueWhiteColorDic = _blueWhiteColorDic;

static CThemeManager* _sharedThemeManager = nil;
+ (CThemeManager*) sharedThemeManager
{
	if (_sharedThemeManager == nil)
	{
		_sharedThemeManager = [[CThemeManager alloc] init];
	}	
	return _sharedThemeManager;
}

+ (id) alloc
{
	NSAssert(_sharedThemeManager == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void) purgeSharedThemeManager
{
    _sharedThemeManager.blackWhiteColorDic = nil;
    _sharedThemeManager.blueWhiteColorDic = nil;
    
    
}

- (id) init
{
	if ((self = [super init])) 
	{
        NSMutableDictionary* blackWhiteDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.blackWhiteColorDic = blackWhiteDic;
        

        NSMutableDictionary* blueWhiteDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.blueWhiteColorDic = blueWhiteDic;
        
        
        [self loadThemeColorDic:@"t0_colorDic.plist" colorDic:self.blackWhiteColorDic];
        [self loadThemeColorDic:@"t1_colorDic.plist" colorDic:self.blueWhiteColorDic];
    }
    
    return self;
}

-(void) loadThemeColorDic:(NSString*)dicName colorDic:(NSMutableDictionary*)colorDic
{
    // black white theme color map
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:dicName ofType:nil];
    if (bundlePath) 
    {
        NSMutableDictionary* tempColorDic = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
        for (NSString* key in tempColorDic) 
        {
            NSString* colorStrValue = [tempColorDic objectForKey:key];
			UIColor* color = nil;
            NSArray* colorValueArr = [colorStrValue componentsSeparatedByString:@"|"];
            /**
             *  R(red:0-255)|G(green:0-255)|B(blue:0-255)
             */
			if (colorValueArr.count == 3) {
				float redValue = [[colorValueArr objectAtIndex:0] floatValue]/255.0;
				float greenValue = [[colorValueArr objectAtIndex:1] floatValue]/255.0;
				float blueValue = [[colorValueArr objectAtIndex:2] floatValue]/255.0;
				
				color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0];
			}
            /**
             *  R(red:0-255)|G(green:0-255)|B(blue:0-255)|A(alpha:0-1) 
             *  add by zheliang
             */
            else if (colorValueArr.count == 4) {
                float redValue = [[colorValueArr objectAtIndex:0] floatValue]/255.0;
                float greenValue = [[colorValueArr objectAtIndex:1] floatValue]/255.0;
                float blueValue = [[colorValueArr objectAtIndex:2] floatValue]/255.0;
                float alpha = [[colorValueArr objectAtIndex:3] floatValue];
                color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alpha];
            }

            /**
             *  hexstring(0xffffff或#ffffff或ffffff)|alpha(0-1)
             *  add by zheliang
             */
            else if (colorValueArr.count == 2) {
                color = [UIColor colorWithHexString:[colorValueArr objectAtIndex:0] alpha:[[colorValueArr objectAtIndex:1] floatValue]];
            }
            /**
             *  hexstring(0xffffff或#ffffff或ffffff)
             *  add by zheliang
             */
			else
			{
				color = [UIColor colorWithHexString:colorStrValue];
			}

            [colorDic setValue:color forKey:key];
        }
    }
}

- (void) pushThemeChangedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KAppThemeChangedNotification 
                                                        object:nil];
}

- (NSString*) getThemePrifix:(TThemeType)themeType
{
    if (themeType == eThemeBlueWhite) 
    {
        return @"t1_";
    }
    else if (themeType == eThemeBlackWhite) 
    {
        return @"";
    }
    return @"";
}

- (UIImage*) getBundleImageUnderTheme:(NSString*)imageName
{
    TThemeType themeType = [CConfiguration sharedConfiguration].themeType;
    
    // default直接返回图片
    NSString* themePrefix = [self getThemePrifix:themeType];
    NSString* wrappedImageName = [NSString stringWithFormat:@"%@%@", themePrefix, imageName];
    
    UIImage *image = [[CConfiguration sharedConfiguration] getBundleImage:wrappedImageName];
    
    if(!image){
        image = [[CConfiguration sharedConfiguration] getBundleImage:imageName];
    }
    
    NSAssert(image != nil, [@"图片不存在 " stringByAppendingString:imageName]);
    
    return image;
}

- (UIColor*) getColorUnderTheme:(NSString*)colorName
{
    NSMutableDictionary* colorDic = nil;
    
    TThemeType themeType = [CConfiguration sharedConfiguration].themeType;
    if (themeType == eThemeBlackWhite) 
    {
        colorDic = self.blackWhiteColorDic;
    }
    else if (themeType == eThemeBlueWhite)
    {
        colorDic = self.blueWhiteColorDic;
    }
    
    UIColor * themeColor = [colorDic objectForKey:colorName];
    if(themeColor)
    {
        return themeColor;
    }
    
    //如果在对应皮肤的色彩配置中无法找到对应颜色，则默认使用黑白皮肤中对应颜色，如果依然没有的，用红色（在测试的时候容易发现）
    UIColor * defaultColor = [self.blackWhiteColorDic objectForKey:colorName];
    if(nil == defaultColor)
    {
        defaultColor = [UIColor redColor];
    }
    return defaultColor;
}
@end
