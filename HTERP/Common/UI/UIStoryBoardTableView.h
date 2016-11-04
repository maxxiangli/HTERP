//
//  UIDesignableTableView.h
//
//
//  Created by zheliang on 14-4-28.
//  Copyright (c) 2014年 zheliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryBoardTableView : UITableView

/**
 *  在IB中设置本tableview包含的tablecell的标识集合
 *  句法:"identifier[:quantity][:section-index];"
 *  举例:work-master:1;worker:*;mateial:*:1;
 *  解释:
 *       TableView包含以下的cell和相应的数量以及位置
 *       id           count   section-index
 *       work-master  1        0
 *       work         *        0
 *       mateiral     *        1
 */
@property(nonatomic, strong) NSString *prototypes;

/**
 *  在IB中定义table的section标题
 *  句法:"section-title;"
 * 举例:"人员;材料;"
 */
@property(nonatomic, strong) NSString *sectionTitles;
@end
