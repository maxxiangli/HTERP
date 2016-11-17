//
//  CGuideFirstView.m
//  HTERP
//
//  Created by li xiang on 16/11/17.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CGuideFirstView.h"
#import "HTLoginLoginViewController.h"
#import "CNavigationController.h"
#import "CGuideFirstManager.h"

#define kImageCount 4
#define kIntoButtonRatio 0.8//intoButton相对于pageImageView的高度比
#define kPageControlRatio 0.9//pageControl相对于根视图的高度比

@interface CGuideFirstView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation CGuideFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //    要设置背景图片,创建一个rootImageView作为父视图
        [self createRootImageView];
        //     创建第二层的scrollView
        [self createScrollView];
        //     创建第二层的pageControl
        [self createPageControl];
    }
    return self;
}

#pragma mark 创建rootImageView
-(void)createRootImageView{
    UIImageView *rootImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [rootImageView setImage:BUNDLEIMAGE(@"new_feature_background.png")];
    [self addSubview:rootImageView];
    //    因为父视图是一个imageView,要开启互动,否则无法做任何操作
    [self setUserInteractionEnabled:YES];
}

#pragma mark 创建第二层视图scrollView
-(void)createScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //    设置scrollView内容大小--可滑动范围
    [scrollView setContentSize:CGSizeMake(self.bounds.size.width*kImageCount, 0)];
    //    向其中添加pageImageView
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSInteger i=0; i<kImageCount; i++) {
        //        相对于scrollView内容的位置
        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        NSString *imgPath = [NSString stringWithFormat:@"new_feature_%ld.png",i + 1];
        [pageImageView setImage:BUNDLEIMAGE(imgPath)];
        if ( i == kImageCount - 1 ) {
            [self createIntoButton:pageImageView];
        }
        [scrollView addSubview:pageImageView];
    }
    //    设置分页,否则滚动效果很糟糕
    [scrollView setPagingEnabled:YES];
    //    去掉弹性
    [scrollView setBounces:NO];
    //    去掉滚动条
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    //    设置代理,以便于滑动时改变pageControl
    [scrollView setDelegate:self];
    //    scrollView目前为第二层视图
    [self addSubview:scrollView];
}
#pragma mark 创建最后一页的“立即体验”按钮
-(void)createIntoButton:(UIImageView*)pageImageView{
    //    开启父视图交互
    [pageImageView setUserInteractionEnabled:YES];
    UIButton *intoButton=[[UIButton alloc] init];
    //    设置背景图片
    UIImage *backImage = BUNDLEIMAGE(@"new_feature_finish_button.png");
    UIImage *backImageHL = BUNDLEIMAGE(@"new_feature_finish_button_highlighted.png");
    [intoButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [intoButton setBackgroundImage:backImageHL forState:UIControlStateHighlighted];
    //    设置中心点和大小,大小根据背景
    CGFloat centerX=pageImageView.bounds.size.width/2;
    CGFloat centerY=pageImageView.bounds.size.height * kIntoButtonRatio;
    CGFloat width=backImage.size.width;
    CGFloat height=backImage.size.height;
    [intoButton setBounds:CGRectMake(0, 0, width, height)];
    [intoButton setCenter:CGPointMake(centerX, centerY)];
    //    消息响应
    [intoButton addTarget:self action:@selector(intoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    添加到pageImageView
    [pageImageView addSubview:intoButton];
    
}
#pragma mark "立即体验"按钮消息响应
-(void)intoButtonClick
{
    [[CGuideFirstManager getInstance] showedFirstView];
    
    [self removeFromSuperview];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HTLogin" bundle:nil];
    HTLoginLoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    CNavigationController *navigationController = [[CNavigationController alloc] initWithRootViewController:loginViewController];
//    navigationController.navigationBarHidden = YES;
    [[SharedAPPDelegate getAppRootController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 创建和scrollView同为第二层视图的pageControl
-(void)createPageControl{
    
    _pageControl=[[UIPageControl alloc] init];
    //    设置位置
    [_pageControl setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height * kPageControlRatio)];
    [_pageControl setBounds:CGRectMake(0, 0, 150, 44)];
    //    设置页数
    [_pageControl setNumberOfPages:kImageCount];
    //    设置页面轨道颜色
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    //    注意，父视图不是ScrollView!
    [self addSubview:_pageControl];
}

#pragma mark scrollView的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index=scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_pageControl setCurrentPage:index];
}
@end
