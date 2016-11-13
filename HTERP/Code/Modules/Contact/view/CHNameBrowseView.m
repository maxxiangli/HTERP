//
//  CHNameBrowseView.m
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHNameBrowseView.h"

static const NSInteger kLabelFontSize = 20;
//static const NSInteger kLabelGap = 10;

@interface CHNameBrowseView()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *labelList;

@property (nonatomic, strong) NSArray *textArray;

@end

@implementation CHNameBrowseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGSize size = self.bounds.size;
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(size.width, size.height);
    _scrollView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Private function



#pragma mark - Public function
- (void)addTextFromArray:(NSArray *)texts
{
    if (!texts && [texts count] == 0)
    {
        return;
    }
}

- (void)addText:(NSString *)text
{
    if (!text)
    {
        return;
    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    NSDictionary *atts = @{NSFontAttributeName : font};
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, self.bounds.size.height);
    CGRect rect = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:atts
                                     context:nil];
    
    if ([self.labelList lastObject])
    {
        UILabel *lastLabel = [self.labelList lastObject];
        CGFloat originX = CGRectGetMaxX(lastLabel.frame);
        CGFloat originY = CGRectGetMinY(lastLabel.frame);
        
        CGRect frame = CGRectMake(originX, originY, rect.size.width, rect.size.height);
        UILabel *label = [self makeLabel:frame text:text];
        CGSize contentSize = self.scrollView.contentSize;
        if ((originX + rect.size.width) > contentSize.width)
        {
            self.scrollView.contentSize = CGSizeMake((originX + rect.size.width), contentSize.height);
        }
        
        [self.scrollView addSubview:label];
        [self.labelList addObject:label];
    }
    else
    {
        CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        UILabel *label = [self makeLabel:frame text:text];
        CGSize contentSize = self.scrollView.contentSize;
        if (rect.size.width > contentSize.width)
        {
            self.scrollView.contentSize = CGSizeMake(rect.size.width, contentSize.height);
        }
        
        [self.scrollView addSubview:label];
        [self.labelList addObject:label];
    }
}

- (void)removeTextAfterIndex:(NSInteger)index
{
    if ([self.labelList count] == (index + 1))
    {
        return;
    }
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSInteger n = 0; n < [self.labelList count]; n++)
    {
        if (n > index)
        {
            UILabel *label = self.labelList[n];
            [label removeFromSuperview];
            [indexSet addIndex:n];
        }
    }
    
    [self.labelList removeObjectsAtIndexes:indexSet];
}

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    label.text = text;
    label.backgroundColor = [UIColor yellowColor];
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLabel:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [label addGestureRecognizer:tap];
    
    return label;
}

- (void)handleTapLabel:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        UIView *view = sender.view;
        NSInteger index = [self.labelList indexOfObject:view];
        if (index != NSNotFound)
        {
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(browseView:didSelectedIndex:)])
            {
                [self.delegate browseView:self didSelectedIndex:index];
            }
        }
    }
}

#pragma mark - Property
- (NSMutableArray *)labelList
{
    if (!_labelList)
    {
        _labelList = [NSMutableArray arrayWithCapacity:16];
    }
    return _labelList;
}

@end
