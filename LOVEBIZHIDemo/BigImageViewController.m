//
//  BigImageViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/18.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "BigImageViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "BigImageCollectionViewCell.h"
#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "JWCache.h"
#import "NSString+Tools.h"
#import <MBProgressHUD.h>
@interface BigImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ButtonsDelegate>{
   UICollectionView *_collectionView;
    NSInteger _string;
    NSMutableArray *_dataArray;
    BOOL isMored;
}

@end

@implementation BigImageViewController
- (void)popToDetailView:(NSString *)string{
    DetailViewController *tvc =[[DetailViewController alloc]init];
    [tvc setModelWith:string];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTopView];
//    self.navigationController.delegate =self;
//    self.navigationController.navigationBar.alpha = 0.300;
//    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
}
//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (viewController == self) {
//        self.navigationController.navigationBar.alpha = 0.100;
//    }else{
//        self.navigationController.navigationBar.alpha =1;
//    }
//}

- (void)createTopView {
    CGRect frame = CGRectMake(0,64, self.view.frame.size.width,height(self.view)-64);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createTwoLayout]];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    _collectionView.dataSource = self;
    _collectionView.delegate =self;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    //    _collectionView.contentSize = CGSizeMake(width(self.view),(width(self.view)-24)*16/26);
    _collectionView.userInteractionEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator =NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[BigImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellcollId1"];
    [self.view addSubview:_collectionView];

}
- (void)setModelWith:(NSInteger )string AndData:(NSString *)model {
    _string = string;
    [self createDataWithString:model];
}
- (void)createDataWithString:(NSString *)string {
    _dataArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(string)];
    if (cacheData) {
        FristModel *fristModel = [[FristModel alloc]initWithData:cacheData error:nil];
        for (DataModel *dataModel in fristModel.data) {
            [_dataArray addObject:dataModel];
        }
        [_collectionView reloadData];
        _collectionView.contentOffset = CGPointMake(width(self.view)*(_string%60), 0);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         FristModel *fristModel = [[FristModel alloc]initWithData:responseObject error:nil];
        for (DataModel *dataModel in fristModel.data) {
            [_dataArray addObject:dataModel];
        }
        [_collectionView reloadData];
        
        _collectionView.contentOffset = CGPointMake(width(self.view)*(_string%60), 0);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(string)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (UICollectionViewLayout *)createTwoLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(width(self.view),height(self.view)+50);
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    layout.headerReferenceSize = CGSizeMake(0, 0);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    layout.sectionHeadersPinToVisibleBounds = NO;
    return layout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BigImageCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellcollId1" forIndexPath:indexPath];
    cell1.delegate = self;
       cell1.backgroundColor = [UIColor whiteColor];
    [cell1 setModelWithData:_dataArray[indexPath.row]];
    cell1.userInteractionEnabled = YES;
//    [cell1 setModel:_dataArray[indexPath.row]];
    return cell1;
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
