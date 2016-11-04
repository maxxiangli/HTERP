//
//  UIStoryBoardTableViewCell.h
//  QQStock
//
//  Created by zheliang on 14/11/18.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewCell_StoryBoardDelegate <NSObject>
@optional
- (void)doAction:(NSIndexPath*)indexPath tag:(NSInteger)tag data:(id)data;
@end
@interface UITableViewCell_StoryBoard : UITableViewCell
@property (nonatomic, weak) NSObject<UITableViewCell_StoryBoardDelegate>* delegate;
@property (nonatomic, retain) id cellData;
@property (nonatomic, weak) UITableView* tableView;

- (void)setData:(id)data;
- (void)doAction:(NSInteger)tag;
- (NSIndexPath *)indexPath;

@end
