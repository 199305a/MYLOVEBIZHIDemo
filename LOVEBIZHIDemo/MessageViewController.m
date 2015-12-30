//
//  MessageViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "MessageViewController.h"
#import "DetailViewController.h"
#import "DBManager.h"

@interface MessageViewController ()
{
    NSMutableArray *_dataSoucre;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSoucre = [NSMutableArray arrayWithArray:[[DBManager sharedManager]readModels]];
    DetailViewController *dvc = [[DetailViewController alloc]init];
    [dvc setModelWithShoucang:_dataSoucre];
    [self.navigationController pushViewController:dvc animated:YES];
    // Do any additional setup after loading the view.
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
