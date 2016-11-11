//
//  CAlertWaitingViewStyleOne.m
//  QQStock_lixiang
//
//  Created by xiang li on 13-7-15.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "CAlertWaitingViewStyleOne.h"

#define kLeftgargin     12
#define kRightgargin    32
#define kLableFontMax   14
#define kLableFontMin   10

@interface CAlertWaitingViewStyleOne ()
@property(nonatomic, assign) float delaySeconds;
@property(nonatomic, retain) UIImageView *tipsBgView;
@property(nonatomic, retain) UILabel *tipsLable;
@end

@implementation CAlertWaitingViewStyleOne

- (id)initSuccessMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)delay
{
    return [self initSuccessMessage:message duration:0.4];
}

- (id)initFailMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)delay
{
    return [self initFailMessage:message duration:0.6];
}

- (id)initSuccessMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    CGRect frame = [CConfiguration deviceScreenBounds];
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setWindowLevel:UIWindowLevelStatusBar];
        
        self.delaySeconds = duration;
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6f;
        [self addSubview:bgView];
        
        
        UIImage *img = BUNDLEIMAGE(@"alertViewBg_success.png");
        self.tipsBgView =  [[UIImageView alloc] initWithImage:img] ;
        self.tipsBgView.frame = CGRectMake((self.frame.size.width - img.size.width) / 2, (self.frame.size.height - img.size.height) / 2, img.size.width, img.size.height);
        [self addSubview: self.tipsBgView];
        
        self.tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, img.size.width - 20, 70)] ;
        self.tipsLable.text = message;
        self.tipsLable.numberOfLines = 0;
        self.tipsLable.textColor = TC_AlertWaitingViewTextColor;
        self.tipsLable.backgroundColor = [UIColor clearColor];
        self.tipsLable.textAlignment = NSTextAlignmentCenter;
        self.tipsLable.font = [UIFont systemFontOfSize:16];
        [self.tipsBgView addSubview:self.tipsLable];
    }
    return self;
}

- (id)initFailMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    CGRect frame = [CConfiguration deviceScreenBounds];
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setWindowLevel:UIWindowLevelStatusBar];
        
        self.delaySeconds = duration;
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6f;
        [self addSubview:bgView];
        
        
        UIImage *img = BUNDLEIMAGE(@"alertViewBg_fail.png");
        self.tipsBgView =  [[UIImageView alloc] initWithImage:img] ;
        self.tipsBgView.frame = CGRectMake((self.frame.size.width - img.size.width) / 2, (self.frame.size.height - img.size.height) / 2, img.size.width, img.size.height);
        [self addSubview: self.tipsBgView];
        
        self.tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, img.size.width - 20, 70)] ;
        self.tipsLable.text = message;
        self.tipsLable.numberOfLines = 0;
        self.tipsLable.textColor = TC_AlertWaitingViewTextColor;
        self.tipsLable.backgroundColor = [UIColor clearColor];
        self.tipsLable.textAlignment = NSTextAlignmentCenter;
        self.tipsLable.font = [UIFont systemFontOfSize:16];
        self.tipsLable.adjustsFontSizeToFitWidth = YES;
        [self.tipsBgView addSubview:self.tipsLable];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withFailMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)duration
{
    CGRect selfFrame = [CConfiguration deviceScreenBounds];
    self = [super initWithFrame:selfFrame];
    if(self)
    {
        [self setWindowLevel:UIWindowLevelStatusBar];
        
        self.delaySeconds = duration;
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
        
        UIImage *img = BUNDLEIMAGE(@"alertViewBg_fail.png");
        self.tipsBgView =  [[UIImageView alloc] initWithImage:img] ;
        self.tipsBgView.frame = CGRectMake((frame.size.width - img.size.width)/2, (frame.size.height - img.size.height)/2, img.size.width, img.size.height);
        [self addSubview: self.tipsBgView];
        
        self.tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, img.size.width - 20, 70)] ;
        self.tipsLable.text = message;
        self.tipsLable.numberOfLines = 0;
        self.tipsLable.textColor = TC_AlertWaitingViewTextColor;
        self.tipsLable.backgroundColor = [UIColor clearColor];
        self.tipsLable.textAlignment = NSTextAlignmentCenter;
        self.tipsLable.font = [UIFont systemFontOfSize:16];
        self.tipsLable.adjustsFontSizeToFitWidth = YES;
        [self.tipsBgView addSubview:self.tipsLable];
    }
    return self;

}

-(id)initWithImageName:(NSString *)imageName closeAftherDelay:(NSTimeInterval)duration
{
    CGRect selfFrame = [CConfiguration deviceScreenBounds];
    self = [super initWithFrame:selfFrame];
    if(self)
    {
        [self setWindowLevel:UIWindowLevelStatusBar];
        
        self.delaySeconds = duration;
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
        [self addSubview:bgView];
        
        
        UIImage *img = BUNDLEIMAGE_C(imageName);
        self.tipsBgView =  [[UIImageView alloc] initWithImage:img] ;
        self.tipsBgView.frame = CGRectMake((selfFrame.size.width - img.size.width)/2, (selfFrame.size.height - img.size.height)/2, img.size.width, img.size.height);
        [self addSubview: self.tipsBgView];
    }
    return self;

}

- (void)dealloc
{
    self.tipsLable = nil;
    self.tipsBgView = nil;
    
    
}

- (void)show
{
    
    self.alpha = 0.0f;
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:self.delaySeconds
                     animations:^(void){
                         
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(hideView) withObject:nil afterDelay:self.delaySeconds];
                     }];
}

- (void)becomeKeyWindow
{
	[super becomeKeyWindow];
	
}

- (void)resignKeyWindow
{
	[super resignKeyWindow];

}

- (void)close
{
    if ( self )
    {
//        [self resignKeyWindow];
//		NSArray *windows = [UIApplication sharedApplication].windows;
//		if (windows && windows.count) {
//			UIWindow *theWindow = [windows firstObject];
//			[theWindow makeKeyAndVisible];
//		}
		NSArray *windows = [[UIApplication sharedApplication] windows];
		UIWindow *theKeyWindow = nil;
		if ((windows.count > 1) || ![UIApplication sharedApplication].keyWindow) {
			for (UIWindow *theWindow in windows) {
				if ([theWindow isMemberOfClass:[UIWindow class]]) {
					theKeyWindow = theWindow;
				}
			}
		} else {
			theKeyWindow = [[UIApplication sharedApplication] keyWindow];
		}
		[theKeyWindow makeKeyAndVisible];
		
    }
}

- (void)hideView
{
    [UIView animateWithDuration:self.delaySeconds
                     animations:^(void){
                         
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self close];
                     }];
}

- (void)setTipsLabelFont:(CGFloat)font
{
    self.tipsLable.font = [UIFont systemFontOfSize:font];
}

-(void)hiddenAlertViewImmediately
{
    self.alpha = 0.0f;
    [self close];
}
@end
