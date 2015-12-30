//
//  SetViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "SetViewController.h"
#import "UIView+Common.h"
#import "JWCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImage+WebP.h>
#import "DBManager.h"
@interface SetViewController ()
{
   
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView {
   UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(width(self.view)/2-70,height(self.view)/5, 140, 140);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
     [button setTitle:[NSString stringWithFormat:@"清理缓存(%.1fMb)",[JWCache getCacheLength]] forState:UIControlStateNormal];
    button.layer.cornerRadius = 70;
    [button setBackgroundColor:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(width(self.view)/2-70,maxY(button)+50,140, 140);
    [button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setTitle:[NSString stringWithFormat:@"删除所有收藏(%ld条)",[[DBManager sharedManager] getCountsFromApp]] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    button2.layer.cornerRadius = 70;
    [button2 setBackgroundColor:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
    [self.view addSubview:button];
    [self.view addSubview:button2];
}
- (void)buttonClick:(UIButton *)button{
//    [UIView animateWithDuration:0.5 animations:^{
//        button.transform = CGAffineTransformMakeScale(2, 2);
//        button.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        button.transform = CGAffineTransformMakeScale(1, 1);
//        button.alpha = 1;
//    }];
    NSLog(@"%@",[JWCache cacheDirectory]);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您有%.1fMb缓存，确定清理吗？", [JWCache getCacheLength]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JWCache resetCache];
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"清理完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL];
        [controller1 addAction:action2];
        [self presentViewController:controller1 animated:YES completion:NULL];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [controller addAction:action3];
    [controller addAction:action1];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)buttonClick2:(UIButton *)button{
    //    [UIView animateWithDuration:0.5 animations:^{
    //        button.transform = CGAffineTransformMakeScale(2, 2);
    //        button.alpha = 0.3;
    //    } completion:^(BOOL finished) {
    //        button.transform = CGAffineTransformMakeScale(1, 1);
    //        button.alpha = 1;
    //    }];
    NSLog(@"%@",[JWCache cacheDirectory]);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您有%ld条收藏，确定删除吗？",[[DBManager sharedManager] getCountsFromApp]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DBManager sharedManager]deleteModelForAppId];
        UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"清理完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL];
        [controller1 addAction:action2];
        [self presentViewController:controller1 animated:YES completion:NULL];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [controller addAction:action3];
    [controller addAction:action1];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
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
