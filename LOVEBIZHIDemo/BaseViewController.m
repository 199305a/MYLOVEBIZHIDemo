//
//  BaseViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "BaseViewController.h"
#import <MMDrawerBarButtonItem.h>
#import "LeftDrawerTableViewController.h"
#import <UIViewController+MMDrawerController.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    // Do any additional setup after loading the view.
}
- (void)setupLeftMenuButton {
    
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(leftdraweerButtonPress:)];
    leftDrawerButton.image = [[UIImage imageNamed:@"menu@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftDrawerButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES
     ];
    //leftDrawerButton.image = [[UIImage imageNamed:@"abs__ic_ab_back_holo_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationItem setRightBarButtonItem:[self createBarItemWithImage:@"btn_nav_search@2x"] animated:YES];
}
- (void)leftdraweerButtonPress:(id)sent {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (MMDrawerBarButtonItem *)createBarItemWithImage:(NSString *)imageName {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * imageRight = [UIImage imageNamed:imageName];
    rightButton.frame = CGRectMake(0, 0, 40, imageRight.size.height);
    [rightButton setImage:imageRight forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return [[MMDrawerBarButtonItem alloc] initWithCustomView:rightButton];
}
- (void)clickButton:(UIButton *)button {
    
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

@end
