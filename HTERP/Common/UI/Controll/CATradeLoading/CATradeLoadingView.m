//
//  CATradeLoadingView.m
//  QQStock
//
//  Created by michaelxing on 15/3/24.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CATradeLoadingView.h"
//#import "CATradeGlobal.h"

@interface CATradeLoadingView()

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *CircleView;
@property (weak, nonatomic) IBOutlet UIView *clipCircleView;
@property (weak, nonatomic) IBOutlet UIView *bigCircleView;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (retain, nonatomic) UIView            *maskView;

@end
@implementation CATradeLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CATradeLoadingView*)showLoadingViewAddedTo:(UIView *)view {
    NSArray *loadingNlb = [[NSBundle mainBundle] loadNibNamed:@"CATradeLoadingView" owner:self options:nil];
    CATradeLoadingView *loadingView = (CATradeLoadingView *)[loadingNlb objectAtIndex:0];
    [loadingView startLoading:view];
    return loadingView ;
}

+ (BOOL)hideLoadingViewForView:(UIView *)view  {
    CATradeLoadingView *loadingView = [self LoadingViewForView:view];
    if (loadingView != nil) {
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (NSUInteger)hideAllLoadingViewsForView:(UIView *)view {
    NSArray *loadingViews = [CATradeLoadingView allLoadingViewsForView:view];
    for (CATradeLoadingView *loadingView in loadingViews) {
        [loadingView stopLoading];
        
        [loadingView removeFromSuperview];
    }
    return [loadingViews count];
}

+ (CATradeLoadingView*)LoadingViewForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (CATradeLoadingView *)subview;
        }
    }
    return nil;
}

+ (NSArray *)allLoadingViewsForView:(UIView *)view {
    NSMutableArray *loadingViews = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [loadingViews addObject:aView];
        }
    }
    return [NSArray arrayWithArray:loadingViews];
}

- (id)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}
- (void)awakeFromNib
{
    self.backgroundColor  = [UIColor clearColor];
    self.CircleView.backgroundColor = [UIColor clearColor];
    self.CircleView.layer.cornerRadius = 4.0f;
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 10.0f;
    self.bigCircleView.layer.cornerRadius = 35;
    self.bigCircleView.layer.borderWidth = 2.f;
    self.bigCircleView.layer.borderColor = ([UIColor colorWithRed:11.0/255 green:123.0/255 blue:205.0/255 alpha:1.0]).CGColor;
    self.contentImageView.image = BUNDLEIMAGE(@"atrade_loading_logo.png");
    [self setUpLoadingBackGroundColor:THEMECOLOR(@"ATradeControllerLoadingViewBackGroundColor")];
    self.hidden = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
//    self.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
}


- (void)setUpFrame:(CGRect)frame
{
    self.frame = frame;
}

- (void)setUpBackgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (void)rotate
{
    CABasicAnimation *rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.contentImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -300;
    self.contentImageView.layer.transform = rotationAndPerspectiveTransform;
    
    
//    CAKeyframeAnimation *alphaRotationAnimation;
//    alphaRotationAnimation = [CAKeyframeAnimation animation];
//    alphaRotationAnimation.keyPath = @"opacity";
//    alphaRotationAnimation.values = @[@1, @0.4, @1];
//    alphaRotationAnimation.keyTimes = @[@0, @0.6, @1];
//    alphaRotationAnimation.duration = 2.0;
//    alphaRotationAnimation.additive = NO;
//    alphaRotationAnimation.repeatCount = INFINITY;
//    alphaRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    
//    [self.contentImageView.layer addAnimation:alphaRotationAnimation forKey:@"alphaRotationAnimation"];
    
    
    CABasicAnimation *circleRotationAnimation;
    
    circleRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleRotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    circleRotationAnimation.duration = 1.2;
    circleRotationAnimation.cumulative = YES;
    circleRotationAnimation.repeatCount = INFINITY;
    circleRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.CircleView.layer addAnimation:circleRotationAnimation forKey:@"CircleRotationAnimation"];
}


- (void)setUpCircleFrame:(CGRect)frame
{
    self.CircleView.frame = frame;
}
- (void)setUpImageViewFrame:(CGRect)frame
{
    self.contentImageView.frame = frame;
}

- (void)setUpLoadingBackGroundColor:(UIColor *)color
{
    self.backGroundView.backgroundColor = color;
}

- (void)startLoading:(UIView *)parentView
{
    //默认加到屏幕中间
    self.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0 - kNavigationBarHeight);
    
     //加在view上
    [parentView addSubview:self];
    [parentView bringSubviewToFront:self];
    
    //禁用parentView点击
    parentView.userInteractionEnabled = NO;
  
    [self setHidden:NO];
    [self rotate];
}

- (void)startLoadingOnCurrentWindow
{
    self.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
    self.frame = [UIScreen mainScreen].bounds;
    //加在window上。
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    
    [self setHidden:NO];
    [self rotate];
}

- (void)setUpLoadingViewCenter:(CGPoint)center
{
    self.center = center;
}

- (void)startLoading
{
    [self setHidden:NO];
    [self rotate];
}

- (void)stopLoading
{
    self.superview.userInteractionEnabled = YES;
    [self removeFromSuperview];
    [self setHidden:YES];
}


@end
