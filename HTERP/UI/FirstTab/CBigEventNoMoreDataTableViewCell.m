//
//  CBigEventNoMoreDataTableViewCell.m
//  QQStock
//
//  Created by mazingwang on 16/6/21.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CBigEventNoMoreDataTableViewCell.h"

@interface CBigEventNoMoreDataTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation CBigEventNoMoreDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = TC_DefaultBackgroundColor;;
    self.backgroundColor = TC_DefaultBackgroundColor;
    self.line.backgroundColor = TC_NewsListSepratorColor;
    self.tipsLabel.textColor = TC_DetailNewsHeadNameColor;
    
    self.tipsLabel.font = [UIFont systemFontOfSize:FS_StockDetailNewsCell_Title];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        self.tipsLabel.text = (NSString *)data;
    }
}

@end
