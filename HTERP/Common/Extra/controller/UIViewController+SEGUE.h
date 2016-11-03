//
//  UIViewController+SEGUE.h
//  vovo
//
//  Created by zheliang on 周六 2014-04-26.
//  Copyright (c) 2014年 zheliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SEGUE)
- (IBAction)unwindSegue:(UIStoryboardSegue *)sender;
- (IBAction)dismissSelf:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
@end
