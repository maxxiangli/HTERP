//
// UIViewController+SEGUE.m
// vovo
//
// Created by zheliang on 周六 2014-04-26.
// Copyright (c) 2014年 zheliang. All rights reserved.
//

#import "UIViewController+SEGUE.h"

@implementation UIViewController (SEGUE)
- (IBAction)unwindSegue:(UIStoryboardSegue*)sender
{
}

- (IBAction)dismissSelf:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
