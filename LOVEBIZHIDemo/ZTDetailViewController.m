//
//  ZTDetailViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/18.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "ZTDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "UIView+Common.h"
#import "FristCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImage+WebP.h>
#import "DetailViewController.h"
#import "BigImageViewController.h"
#import <MJRefresh.h>
#import "JWCache.h"
#import <MBProgressHUD.h>
#import "NSString+Tools.h"
@interface ZTDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ButtonDelegate,downLoadButtonDelegate>
{
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    NSString *_string;
    UIView *_view;
    FristModel *_model;
    UILabel *_label;
    UIImageView *_imageView;
    UILabel *_downlabel;
}
@end

@implementation ZTDetailViewController
- (void)popToDetailViewwithError:(NSError *)string {
    if (string) {
        _downlabel.text = @"下载失败";
    }else {
        _downlabel.text = @"下载成功";
    }
    _downlabel.textAlignment = NSTextAlignmentCenter;
    _downlabel.textColor = [UIColor whiteColor];
    _downlabel.layer.cornerRadius = 5;
    _downlabel.clipsToBounds = YES;
    _downlabel.backgroundColor = [UIColor blackColor];
    _downlabel.alpha = 1;
    
    _downlabel.frame = CGRectMake(width(self.view)/2-80, height(self.view)*8/9, 160, 40);
    [UIView animateWithDuration: 2 animations:^{
        _downlabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        _downlabel.frame = CGRectZero;
        _downlabel.alpha = 1;
    }];
    
}

- (void)popToDetailView:(NSString *)string{
    DetailViewController *tvc =[[DetailViewController alloc]init];
    [tvc setModelWith:string];
    [self.navigationController pushViewController:tvc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createCollectionView];
    [self createTopView];
    _dataArray = [NSMutableArray new];
    _downlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_downlabel];
    // Do any additional setup after loading the view.
}
- (void)setModelWithstring:(NSString *)string {
    _string =string;
//    [self createDataWithString:string];
}
- (void)createTopView {
    _view = [[UIView alloc]initWithFrame:CGRectMake(5,5, width(self.view),height(self.view)*16/100)];
    _imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,height(_view), height(_view))];
    _label =[[UILabel alloc]initWithFrame:CGRectMake(height(_view), 0, width(_view)-height(_view), height(_view))];
    _label.numberOfLines = 0;
    _label.adjustsFontSizeToFitWidth = YES;
      _label.backgroundColor = [UIColor whiteColor];
    _label.textColor = [UIColor lightGrayColor];
    [_view addSubview:_imageView];
    [_view addSubview:_label];
    _view.layer.shadowColor = [UIColor grayColor].CGColor;
    _view.layer.shadowOffset =CGSizeMake(3, 3);
    _view.layer.shadowRadius = 4;
    _view.layer.shadowOpacity = 0.7;
    _view.backgroundColor = [UIColor whiteColor];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageViewController *bvc =[[BigImageViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
    [bvc setModelWith:indexPath.row AndData:_string];
}

- (void)loadDataForNetabout:(BOOL )isMore{
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray.count%60 != 0) {
            return;
        }
        page = _dataArray.count/60 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    NSString *string = [NSString stringWithFormat:@"&p=%ld",page];
    NSString *url = [_string stringByAppendingString:string];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        _model = [[FristModel alloc]initWithData:cacheData error:nil];
        for (DataModel *dataModel in _model.data) {
            [_dataArray addObject:dataModel];
        }
        [self createData];
        [_collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];

        return;
    }
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _model = [[FristModel alloc]initWithData:responseObject error:nil];
        for (DataModel *dataModel in _model.data) {
            [_dataArray addObject:dataModel];
        }
        [self createData];
        [_collectionView reloadData];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(url)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)createData {
    _label.text = [NSString stringWithFormat:@"%@",_model.desc];
//    NSLog(@"%@",_model.desc);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:nil];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell1.layer.shadowColor = [UIColor grayColor].CGColor;
    cell1.layer.shadowOffset =CGSizeMake(2, 2);
    cell1.layer.shadowRadius = 2;
    cell1.layer.shadowOpacity = 0.5;
    cell1.downLoaddelegate = self;
    cell1.backgroundColor = [UIColor whiteColor];
    cell1.delegate = self;
    [cell1 setModel:_dataArray[indexPath.row]With:indexPath.row];
    return cell1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)createCollectionView {
    CGRect frame = CGRectMake(0,64, self.view.frame.size.width,height(self.view)-64);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.bounces = NO;
    [_collectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [self.view addSubview:_collectionView];
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForNetabout:NO];
    }];
    _collectionView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNetabout:YES];
    }];
    _collectionView.mj_footer = refreshFooter;
    [refreshHeader beginRefreshing];
}
- (UICollectionViewLayout *)createLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-24)/2,(width(self.view)-24)*16/26);
    layout.sectionInset = UIEdgeInsetsMake(12,7,5,7);
    
    layout.headerReferenceSize = CGSizeMake(50, height(self.view)*16/100);
    return layout;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
        //            view.backgroundColor = [UIColor greenColor];
        [view addSubview:_view];
    }
return view;
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
