//
//  CNoDataView.m
//  QQStock
//
//  Created by zheliang on 16/6/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CNoDataView.h"

@interface CNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation CNoDataView
+ (CNoDataView*)addedTo:(UIView *)view image:(UIImage*)image text:(NSString*)text{
    CNoDataView* noDataView = [self noDataViewForView:view];
    if (noDataView) {
        noDataView.image = image;
        noDataView.text = text;
        return noDataView;
    }
    else
    {
        NSArray *loadingNlb = [[NSBundle mainBundle] loadNibNamed:@"CNoDataView" owner:self options:nil];
        CNoDataView *noDataView = (CNoDataView *)[loadingNlb objectAtIndex:0];
        noDataView.image = image;
        noDataView.text = text;
        //默认加到屏幕中间
        noDataView.center = CGPointMake(view.width/2.0, view.height/2.0);
        
        //加在view上
        [view addSubview:noDataView];
        return noDataView ;
    }

}

+ (BOOL)hideForView:(UIView *)view  {
    CNoDataView *noDataView = [self noDataViewForView:view];
    if (noDataView != nil) {
        [noDataView removeFromSuperview];
        return YES;
    }
    return NO;
}


+ (CNoDataView*)noDataViewForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (CNoDataView *)subview;
        }
    }
    return nil;
}



- (id)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageVIew.image = image;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}


@end
