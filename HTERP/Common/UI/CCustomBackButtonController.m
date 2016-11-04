//
//  CATradeControllerBase.m
//  QQStock
//
//  Created by zheliang on 15/4/16.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "CCustomBackButtonController.h"

@interface CCustomBackButtonController ()

@end

@implementation CCustomBackButtonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self addBackButton];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)addBackButton
{
    if ((isThaniOS6)) return;
    NSString *leftBtnTitle = @"返回";
    

    
    CCustomButton *button = [CCustomButton buttonWithTitle:leftBtnTitle style:eCustomButtonStyleLeftAngle];
    
    [button addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}

- (void)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
