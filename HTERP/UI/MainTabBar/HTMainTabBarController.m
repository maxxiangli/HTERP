//
//  HTMainTabBarController.m
//  HTERP
//
//  Created by li xiang on 16/11/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "HTMainTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface HTMainTabBarController ()

@end

@implementation HTMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"HTFirstTabStoryboard" bundle:nil];
    FirstViewController *firstController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"first" image:BUNDLEIMAGE(@"first.png") tag:0];
    firstController.tabBarItem = item;
    self.viewControllers = @[firstController];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
