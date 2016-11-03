//
// UIColor+HexColor.m
// BuildeTower
//
// Created by zheliang on 13-6-26.
// Copyright (c) 2013年 zheliang. All rights reserved.
//

#import "UIColor+Extra.h"

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}
+ (UIColor*)colorWithHex:(NSUInteger)hexValue
{
    return [[self class] colorWithHex:hexValue alpha:1];
}

+ (UIColor*)colorWithHex:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:( (hexValue >> 16) & 0xff ) / 255.0
                           green:( (hexValue >> 8) & 0xff ) / 255.0
                            blue:( (hexValue) & 0xff ) / 255.0
                           alpha:alpha];
}

+ (UIColor*)randomColor
{
    return [UIColor colorWithRed:( (arc4random() % 255) / 255.0 )
                           green:( (arc4random() % 255) / 255.0 )
                            blue:( (arc4random() % 255) / 255.0 )
                           alpha:( (arc4random() % 255) / 255.0 )];
}

+ (UIColor*)randomDeepColor
{
    return [UIColor colorWithRed:( (arc4random() % 128) / 255.0 )
                           green:( (arc4random() % 128) / 255.0 )
                            blue:( (arc4random() % 128) / 255.0 )
                           alpha:( ( (arc4random() % 128) + 128 ) / 255.0 )];
}

+ (UIColor*)randomDeepColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:( (arc4random() % 128) / 255.0 )
                           green:( (arc4random() % 128) / 255.0 )
                            blue:( (arc4random() % 128) / 255.0 )
                           alpha:( alpha )];
}

- (UIColor*)colorByNegtive
{
    CGFloat    red, green, blue, alpha;

    [self getRed:&red green:&green blue:&blue alpha:&alpha];

    return [UIColor colorWithRed:1 - red green:1 - green blue:1 - blue alpha:alpha];
}

- (UIColor*)colorForForeground
{
    // HSL
    CGFloat    hue, saturation, brightness, alpha;

    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    brightness = ( (int)(brightness * 255 + 127) % 255 ) / 255.0;
    hue        = ( (int)(hue * 255 + 127) % 255 ) / 255.0;
    saturation = ( (int)(saturation * 255 + 127) % 255 ) / 255.0;

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
} /* colorForForeground */

- (NSUInteger)hexValue
{
    CGFloat    red, green, blue, alpha;

    [self getRed:&red green:&green blue:&blue alpha:&alpha];

    return ( ( ( (NSInteger)(red * 255) ) & 0xff ) << 16 )
           | ( ( ( (NSInteger)(green * 255) ) & 0xff ) << 8 )
           | ( ( ( (NSInteger)(blue * 255) ) & 0xff ) )
    ;
}

/*
 *   RGB > HSB(HSV)
 *
 *   Ha=0~359, Hb=0~359
 *   Sa<=100/3, Sb<=100/3,
 *   Va<=100/2, Vb<=100/2,  and Va-Vb>=20
 *
 */
- (UIColor*)colorForForeground2
{
   #if 0
        CGFloat    red, green, blue, alpha;

        [self getRed:&red green:&green blue:&blue alpha:&alpha];

        CGFloat    L1 = 0.2126 * powf(red, 2.2) +
                        0.7152 * powf(green, 2.2) +
                        0.0722 * powf(blue, 2.2);
   #endif
    CGFloat    hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    CGFloat    L1 = brightness;

    if (L1 < 0.5)
    {
        return [UIColor whiteColor];
    }
    else
    {
        return [UIColor blackColor];
    }
} /* colorForForeground2 */

+ (NSArray*)darkFlatColors
{
    static NSArray           *sharedDarkFlatColors = nil;
    static dispatch_once_t    onceToken;

    dispatch_once(&onceToken, ^{
        sharedDarkFlatColors = @[ COLOR(0xD24D57), // Chestnut Rose
                                  COLOR(0xF22613), // Pomegranate
                                  COLOR(0xFF0000), // red
                                  COLOR(0xD91E18), // Thunderbird
                                  COLOR(0x96281B), // Old Brick
                                  COLOR(0xEF4836), // sFlamingo
                                  COLOR(0xD64541), // Valencia
                                  COLOR(0xC0392B), // Tall Poppy
                                  COLOR(0xCF000F), // Monza
                                  COLOR(0xE74C3C), // Cinnabar
                                  COLOR(0xDB0A5B), // Razzmatazz
                                  COLOR(0xF64747), // Sunset Orange
                                  COLOR(0xD2527F), // Cabaret
                                  COLOR(0xE08283), // New York Pink
                                  COLOR(0xF62459), // Radical Red
                                  COLOR(0xE26A6A), // Sunglo
                                  COLOR(0x663399), // rebeccapurple
                                  COLOR(0x674172), // Honey Flower
                                  COLOR(0x913D88), // Plum
                                  COLOR(0x9A12B3), // Seance
                                  COLOR(0xBF55EC), // Medium Purple
                                  COLOR(0xBE90D4), // Light Wisteria
                                  COLOR(0x8E44AD), // Studio
                                  COLOR(0x9B59B6), // Wisteria
                                  COLOR(0x4183D7), // Royal Blue
                                  COLOR(0x59ABE3), // Picton Blue
                                  COLOR(0x81CFE0), // Spray
                                  COLOR(0x52B3D9), // Shakespeare
                                  COLOR(0x22A7F0), // Picton Blue
                                  COLOR(0x3498DB), // Curious Blue
                                  COLOR(0x2C3E50), // Madison
                                  COLOR(0x19B5FE), // Dodger Blue
                                  COLOR(0x336E7B), // Ming
                                  COLOR(0x22313F), // Ebony Clay
                                  COLOR(0x1E8BC3), // Curious Blue
                                  COLOR(0x3A539B), // Chambray
                                  COLOR(0x34495E), // Pickled Bluewood
                                  COLOR(0x67809F), // Hoki
                                  COLOR(0x2574A9), // Jelly Bean
                                  COLOR(0x1F3A93), // Jacksons Purple
                                  COLOR(0x4B77BE), // Steel Blue
                                  COLOR(0x5C97BF), // Fountain Blue
                                  COLOR(0x87D37C), // Gossip
                                  COLOR(0x90C695), // Dark Sea Green
                                  COLOR(0x26A65B), // Eucalyptus
                                  COLOR(0x03C9A9), // Caribbean Green
                                  COLOR(0x1BBC9B), // Mountain Meadow
                                  COLOR(0x1BA39C), // Light Sea Green
                                  COLOR(0x66CC99), // Medium Aquamarine
                                  COLOR(0x36D7B7), // Turquoise
                                  COLOR(0xC8F7C5), // Madang
                                  COLOR(0x86E2D5), // Riptide
                                  COLOR(0x2ECC71), // Shamrock
                                  COLOR(0x16a085), // Mountain Meadow
                                  COLOR(0x3FC380), // Emerald
                                  COLOR(0x019875), // Green Haze
                                  COLOR(0x03A678), // Free Speech Aquamarine
                                  COLOR(0x4DAF7C), // Ocean Green
                                  COLOR(0x2ABB9B), // Jungle Green
                                  COLOR(0x00B16A), // Jade
                                  COLOR(0x1E824C), // Salem
                                  COLOR(0x049372), // Observatory
                                  COLOR(0x26C281), // Jungle Green
                                  COLOR(0xF89406), // California
                                  COLOR(0xEB9532), // Fire Bush
                                  COLOR(0xE87E04), // Tahiti Gold
                                  COLOR(0xF2784B), // Crusta
                                  COLOR(0xEB974E), // Jaffa
                                  COLOR(0xF5AB35), // Lightning Yellow
                                  COLOR(0xD35400), // Burnt Orange
                                  COLOR(0xF39C12), // Buttercup
                                  COLOR(0xF9690E), // Ecstasy
                                  COLOR(0xF27935), // Jaffa
                                  COLOR(0xE67E22), // Zest
                                  COLOR(0x6C7A89), // Lynch
                                  COLOR(0x95A5A6), // Cascade
                                  COLOR(0xABB7B7), // Edward
                                  COLOR(0xBFBFBF), // Silver
                               ];
    });

    return sharedDarkFlatColors;
} /* darkFlatColors */

+ (NSArray*)lightFlatColors
{
    static NSArray           *sharedLightenFlatColors = nil;
    static dispatch_once_t    onceToken;

    dispatch_once(&onceToken, ^{
        sharedLightenFlatColors = @[COLOR(0xFFECDB), // Derby
                                    COLOR(0xF1A9A0), // Wax Flower
                                    COLOR(0xDCC6E0), // Snuff
                                    COLOR(0xAEA8D3), // Wistful
                                    COLOR(0xE4F1FE), // Alice Blue
                                    COLOR(0xC5EFF7), // Humming Bird
                                    COLOR(0x6BB9F0), // Malibu
                                    COLOR(0x89C4F4), // Jordy Blue
                                    COLOR(0xA2DED0), // Aqua Island
                                    COLOR(0x68C3A3), // Silver Tree
                                    COLOR(0x65C6BB), // Downy
                                    COLOR(0xF5D76E), // Cream Can
                                    COLOR(0xF7CA18), // Ripe Lemon
                                    COLOR(0xF4D03F), // Saffron
                                    COLOR(0xFDE3A7), // Cape Honey
                                    COLOR(0xF4B350), // Casablanca
                                    COLOR(0xF9BF3B), // Sandstorm
                                    COLOR(0xD2D7D3), // Pumice
                                    COLOR(0xEEEEEE), // Gallery
                                    COLOR(0xBDC3C7), // Silver Sand
                                    COLOR(0xECF0F1), // Porcelain
                                    COLOR(0xDADFE1), // Iron
                                    COLOR(0xF2F1EF), // Cararra
                                  ];
    });

    return sharedLightenFlatColors;
} /* flatColors */

+ (UIColor*)randomFlatColor
{
    if (arc4random() % 2 == 0)
    {
        return [[[self class] darkFlatColors ] randomObject];
    }

    return [[[self class] lightFlatColors ] randomObject];
}

+ (UIColor*)randomDarkFlatColor
{
    return [[[self class] darkFlatColors ] randomObject];
}

+ (UIColor*)randomLightFlatColor
{
    return [[[self class] lightFlatColors ] randomObject];
}

@end
