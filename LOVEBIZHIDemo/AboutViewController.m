//
//  AboutViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "AboutViewController.h"
#import "UIView+Common.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView {
    UIImageView *imageVeiw = [[UIImageView alloc]initWithFrame:CGRectMake((width(self.view)-114)/2,height(self.view)/5,114,114)];
    imageVeiw.image = [[UIImage imageNamed:@"about.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake((width(self.view)-140)/2, maxY(imageVeiw)+20, 140, 20)];
//    label3.text = @"版本： 1.0";
    label3.font = [UIFont systemFontOfSize:20];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor blackColor];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, maxY(imageVeiw)+40, width(self.view)-80, 200)];
    label.text =@"    免费壁纸  是专业的壁纸类应用，提供海量高清壁纸，还具有试试手气、专题分类、每日美图、美图排行等特色功能。希望我们的应用能让你欢乐，快来用壁纸装扮你的手机吧。";
    label.numberOfLines = 0 ;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    UILabel *label1= [[UILabel alloc]initWithFrame:CGRectMake((width(self.view)-200)/2, height(self.view)-50, 200, 20)];
    label1.text = @"邮箱： 512672312@qq.com";
    label1.font = [UIFont systemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor grayColor];
    UILabel *label2= [[UILabel alloc]initWithFrame:CGRectMake((width(self.view)-140)/2, maxY(label1), 140, 20)];
    label2.text = @"QQ群： 88888888";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor grayColor];
    [self.view addSubview:imageVeiw];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label];
    [self.view addSubview:label3];
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
