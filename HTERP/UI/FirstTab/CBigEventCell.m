//
//  CBigEventCell.m
//  QQStock
//
//  Created by li xiang on 16/6/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "CBigEventCell.h"
#import "CBigEventReminderModel.h"

@interface CBigEventCell()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *monthDay;
@property (weak, nonatomic) IBOutlet UIImageView *dateImgView;
@property (weak, nonatomic) IBOutlet UIImageView *dotImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateImgConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monthDayConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopContraints;

@end

@implementation CBigEventCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = TC_DefaultBackgroundColor;;
    self.backgroundColor = TC_DefaultBackgroundColor;
//    self.dateImgView.image = BUNDLEIMAGE(@"bigEventReminder_dateImg");
//    self.dotImgView.image = BUNDLEIMAGE(@"bigEventReminder_dot");
//    self.lineImgView.image = BUNDLEIMAGE(@"bigEventReminder_verticalImg");
    
    self.monthDay.textColor = TC_DetailNewsHeadNameColor;
    self.content.textColor = TC_DetailNewsHeadNameColor;
    self.title.textColor = TC_DetailNewsDetailColor;
    
    self.content.font = [UIFont systemFontOfSize:FS_StockDetailNewsCell_Title - 1];
    self.title.font = [UIFont systemFontOfSize:FS_StockDetailNewsCell_Title];
}

- (void)hideDateImg:(BOOL)hide
{
    if ( hide )
    {
        self.titleTopContraints.constant = 2;
        self.dateImgConstraints.constant = 0;
        self.monthDayConstraints.constant = 0;
    }
    else
    {
        self.titleTopContraints.constant = 6;
        //self.dateImgConstraints.constant  = BUNDLEIMAGE(@"bigEventReminder_dateImg").size.height;
        self.monthDayConstraints.constant = 5;
    }
}

- (NSMutableAttributedString *)stringWithLinSpacing:(NSString *)str linSpacing:(CGFloat)linSpacing
{
    if ( ![str isKindOfClass:[NSString class]] )
    {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:linSpacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    return attributedString;
}

- (void)setData:(id)data
{
    CBigEventReminderItemModel *model = data;
    if ( ![model isKindOfClass:[CBigEventReminderItemModel class]] )
    {
        return;
    }
    
    self.yearLabel.text = model.year;
    self.monthDay.text = model.monthDay;
    self.title.text = model.typeStr;
    self.content.text = model.content;
    
    if ( [self.title.text isEqualToString:@"龙虎榜"] )
    {
        self.title.textColor = TC_DetailNewsGroupNameColor;
    }
    else
    {
        self.title.textColor = TC_DetailNewsHeadNameColor;
    }
    
    if ( ![self.content.text isKindOfClass:[NSString class]] )
    {
        return;
    }
    
    if ( [model.noticeId isKindOfClass:[NSString class]] && model.noticeId.length )
    {
        NSString *gonggaoStr = @"［查看公告］";
        self.content.text = [NSString stringWithFormat:@"%@%@", self.content.text, gonggaoStr];
        NSMutableAttributedString *attributedString = [self stringWithLinSpacing:self.content.text linSpacing:(self.content.font.pointSize / 3.f)];
        
        NSRange range = NSMakeRange(self.content.text.length - gonggaoStr.length, gonggaoStr.length);
        [attributedString addAttributes:@{NSForegroundColorAttributeName:TC_DetailNewsGroupNameColor} range:range];
        
        self.content.attributedText = attributedString;
    }
    else
    {
        self.content.attributedText = [self stringWithLinSpacing:self.content.text linSpacing:(self.content.font.pointSize / 3.f)];
    }
}
@end
