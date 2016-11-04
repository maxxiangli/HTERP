//
//  CNoDataView.h
//  QQStock
//
//  Created by zheliang on 16/6/13.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNoDataView : UIView
+ (CNoDataView*)addedTo:(UIView *)view image:(UIImage*)image text:(NSString*)text;
+ (BOOL)hideForView:(UIView *)view;
+ (CNoDataView*)noDataViewForView:(UIView *)view;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* text;

@end
