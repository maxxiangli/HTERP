//
//  CATradeAlertLoadingView.m
//  QQStock
//
//  Created by michaelxing on 15/5/13.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CATradeAlertLoadingObject.h"
#import "CATradeLoadingView.h"

@interface CATradeAlertLoadingObject()

@property (nonatomic,retain) CATradeLoadingView *loading;

@end

@implementation CATradeAlertLoadingObject

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSArray *loadingNlb = [[NSBundle mainBundle] loadNibNamed:@"CATradeLoadingView" owner:self options:nil];
        self.loading = (CATradeLoadingView *)[loadingNlb objectAtIndex:0];
    }
    
    return self;
}

//- (void)showWithParentView:(UIView *)parentView
//{
//   
//}
- (void)dealloc
{
    Safe_Release(_loading);
    
    
}

- (void)show
{
    [self.loading startLoading:nil];
}

- (void)hidden
{
    [self.loading stopLoading];
}

- (void)showOnView:(UIView *)view
{
    [self.loading stopLoading];
    [self.loading startLoading:view];
}

- (void)showOnCurrentWindow
{
    [self.loading stopLoading];
    [self.loading startLoadingOnCurrentWindow];
}

- (void)setUpLoadingViewCenter:(CGPoint)center
{
    self.loading.center = center;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [self.loading setUpLoadingBackGroundColor:color];
}

@end
