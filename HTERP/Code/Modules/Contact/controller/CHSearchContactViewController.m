//
//  CHSearchContactViewController.m
//  HTERP
//
//  Created by macbook on 13/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHSearchContactViewController.h"

@interface CHSearchContactViewController ()

@end

@implementation CHSearchContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildRightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private function

- (void)buildRightItem
{
    CCustomButton *cancleButton = [CCustomButton buttonWithTitle:@"取消" style:eCustomButtonStyleSquare];
    [cancleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [cancleButton addTarget:self action:@selector(handleCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

#pragma mark - Action
- (void)handleCancelClick:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:^{
        //Do noting
    }];
}

@end
