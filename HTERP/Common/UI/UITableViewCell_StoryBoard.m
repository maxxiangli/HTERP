//
//  UIStoryBoardTableViewCell.m
//  QQStock
//
//  Created by zheliang on 14/11/18.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "UITableViewCell_StoryBoard.h"


@implementation UITableViewCell_StoryBoard

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
	
}
- (void)doAction:(NSInteger)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doAction:tag:data:)]) {
        if (self.tableView) {
            [self.delegate doAction:[self.tableView indexPathForCell:self] tag:tag data:self.cellData];
        }
    }
}

- (NSIndexPath *)indexPath
{
    return [self.tableView indexPathForCell:self];
}


@end
