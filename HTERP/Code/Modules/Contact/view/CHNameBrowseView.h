//
//  CHNameBrowseView.h
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNameBrowseView;

@protocol CHNameBrowseViewDelegate <NSObject>

- (void)browseView:(CHNameBrowseView *)browseView didSelectedIndex:(NSInteger)index;

@end

@interface CHNameBrowseView : UIView

@property (nonatomic, weak) id<CHNameBrowseViewDelegate> delegate;

//全部重新计算
- (void)addTextFromArray:(NSArray *)texts;

//加在当前文字的末尾
- (void)addText:(NSString *)text;

@end
