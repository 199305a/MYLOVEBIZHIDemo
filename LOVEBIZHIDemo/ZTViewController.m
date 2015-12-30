//
//  ZTViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/19.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "ZTViewController.h"
#import "UIView+Common.h"
#import <MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "SecondModel.h"
#import "ZTTableViewCell.h"
#import "ZTDetailViewController.h"
#import <MBProgressHUD.h>
#import "JWCache.h"
#import "NSString+Tools.h"
@interface ZTViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableVeiw;
    NSMutableArray *_dataArray;
    NSString *_urlstring;
}

@end

@implementation ZTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)createTableView {
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width(self.view), height(self.view))];
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
    _dataArray = [NSMutableArray new];
    [self.view addSubview:_tableVeiw];
    _tableVeiw.backgroundColor = [UIColor whiteColor];
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForNet:NO];
    }];
    _tableVeiw.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNet:YES];
    }];
    _tableVeiw.mj_footer = refreshFooter;
    [refreshHeader beginRefreshing];

}
- (void)loadDataForNet:(BOOL)isMore {
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray.count%60 != 0) {
            return;
        }
        page = _dataArray.count/60 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    NSString *string = [NSString stringWithFormat:@"&p=%d",page];
    NSString *url = [ZTUrl stringByAppendingString:string];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(ZTUrl)];
    if (cacheData) {
        SecondModel *model = [[SecondModel alloc]initWithData:cacheData error:nil];
        for (DatasModel *dataModel in model.data) {
            [_dataArray addObject:dataModel];
        }
        
        [_tableVeiw reloadData];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_tableVeiw.mj_footer endRefreshing]:[_tableVeiw.mj_header endRefreshing];
        return;
    }

    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      SecondModel *model = [[SecondModel alloc]initWithData:responseObject error:nil];
        for (DatasModel *dataModel in model.data) {
            [_dataArray addObject:dataModel];
        }
        
        [_tableVeiw reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(url)];
        isMore?[_tableVeiw.mj_footer endRefreshing]:[_tableVeiw.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isMore?[_tableVeiw.mj_footer endRefreshing]:[_tableVeiw.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTDetailViewController *ztvc = [[ZTDetailViewController alloc]init];
    DatasModel *model = _dataArray[indexPath.row];
    [ztvc setModelWithstring:model.detail];
    [self.navigationController pushViewController:ztvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenter= @"celllId";
    ZTTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indenter];
    if (cell == nil) {
        cell = [[ZTTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenter];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setModelWithString:_dataArray[indexPath.row]];
    return cell;
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
