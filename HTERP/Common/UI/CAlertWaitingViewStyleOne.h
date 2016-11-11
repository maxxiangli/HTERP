//
//  CAlertWaitingViewStyleOne.h
//  QQStock_lixiang
//
//  Created by xiang li on 13-7-15.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**成功失败提示
 *
 */
@interface CAlertWaitingViewStyleOne : UIWindow

//delay时间不可用（使用的是默认值）
- (id)initSuccessMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)delay;
- (id)initFailMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)delay;
//duration时间可用
- (id)initSuccessMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (id)initFailMessage:(NSString *)message duration:(NSTimeInterval)duration;

-(id)initWithFrame:(CGRect)frame withFailMessage:(NSString *)message closeAfterDelay:(NSTimeInterval)delay;

-(id)initWithImageName:(NSString *)imageName closeAftherDelay:(NSTimeInterval)duration;

- (void)show;

//add by jinruinie
-(void)setTipsLabelFont:(CGFloat)font;
-(void)hiddenAlertViewImmediately;

@end
