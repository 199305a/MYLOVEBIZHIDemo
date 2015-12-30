//
//  DetailViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/17.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "UIView+Common.h"
#import "FristCollectionViewCell.h"
#import "BigImageViewController.h"
#import <MJRefresh.h>
#import "NSString+Tools.h"
#import "JWCache.h"
#import <MBProgressHUD.h>
#import <MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
@interface DetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ButtonDelegate,downLoadButtonDelegate>
{
    NSString *_string;
     NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    NSString *_url;
    NSInteger _SB;
    NSString *_string1;
    NSString *_string2;
    NSString *_urlString;
    UILabel *_downlabel;
}
@end

@implementation DetailViewController
- (void)popToDetailView:(NSString *)string{
    DetailViewController *tvc =[[DetailViewController alloc]init];
    [tvc setModelWith:string];
    [self.navigationController pushViewController:tvc animated:YES];
}
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
    _downlabel.frame = CGRectMake(width(self.view)/2-80, height(self.view)*8/9, 160, 40);
    [UIView animateWithDuration: 2 animations:^{
        _downlabel.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        _downlabel.frame = CGRectZero;
        _downlabel.alpha = 1;
    }];
    
}

//- (void)popToDetailView1:(NSString *)string {
//    BigImageViewController *bvc= [[BigImageViewController alloc]init
//                                  ];
//    [bvc setModelWith:string];
//    [self.navigationController pushViewController:bvc animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(leftdraweerButtonPress:)];
//    leftDrawerButton.image = [[UIImage imageNamed:@"menu@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [leftDrawerButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES
//     ];

    if (_dataArray == nil) {
         _dataArray = [NSMutableArray new];
    }
   
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.leftBarButtonItem.title = @"返回";
    if (_collectionView == nil) {
        [self createTopView];
    }
    
    _downlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_downlabel];

    // Do any additional setup after loading the view.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageViewController *bvc =[[BigImageViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
    [bvc setModelWith:indexPath.row AndData:_urlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setModelWith:(NSString *)string {
    _string = SearchDetailUrl;
    _url =string;
    _SB = 1;
//    [self createDataWithString:url];
}
- (void)setModelWith1:(NSString *)string AndString:(NSString *)strng{
    _string = TabelUrl;
    _SB = 0;
    _string1 = string;
    _string2 = strng;
//    [self createDataWithString:url];
}
- (void)setModalWithcaini {
    _SB = 4;
    _urlString = CNURL;
}
- (void)setModalWithShouqi {
    _SB = 3;
    _urlString = SSURL;
    [self createButton];
}
- (void)createButton {
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0,height(self.view)-60,width(self.view), 60)];
    view.alpha = 1;
    view.userInteractionEnabled = YES;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(120, 10, width(self.view)-240, height(view)-20)];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 10;
    [button setTitle:@"再试一次" forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(clickBUtton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [self.view addSubview:view];
}
- (void)clickBUtton {
    [_collectionView.mj_header beginRefreshing];
}
- (void)setModelWithFenxiang:(NSString *)string {
    _SB = 2;
    _string = FENXiangURL;
}
- (void)setModelWithShoucang:(NSMutableArray *)array {
    _SB = 5;
    _dataArray = [NSMutableArray arrayWithArray:array];
    [self createTopView];
    _collectionView.frame = CGRectMake(0, 64, width(self.view), height(self.view)-64);
    [_collectionView reloadData];
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(leftdraweerButtonPress:)];
    leftDrawerButton.image = [[UIImage imageNamed:@"menu@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftDrawerButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES
     ];

}
- (void)leftdraweerButtonPress:(id)sent {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)loadDataForDetailNet:(BOOL)isMore{
    NSString *url = nil;
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray.count%60 != 0) {
            return;
        }
        page = _dataArray.count/60 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    if (_SB == 1) {
        url = [NSString stringWithFormat:_string,_url,page];
        _urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else if (_SB == 0){
        url = [NSString stringWithFormat:_string,_string2,_string1,page];
        _urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else if (_SB == 2){
        NSString *string = [NSString stringWithFormat:@"&p=%d",page];
        _urlString = [_string stringByAppendingString:string];
    }else if (_SB == 5){
        return;
    }
//    NSString *url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _url = [NSString stringWithFormat:_string,1,1];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_urlString)];
    if (cacheData) {
        FristModel *model = [[FristModel alloc]initWithData:cacheData error:nil];
        if (isMore) {
            for (DataModel *dataModel in model.data) {
                [_dataArray addObject:dataModel];
            }
        }else {
            [_dataArray removeAllObjects];
            for (DataModel *dataModel in model.data) {
                [_dataArray addObject:dataModel];
            }
        }
        [_collectionView reloadData];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FristModel *model = [[FristModel alloc]initWithData:responseObject error:nil];
        if (isMore) {
            for (DataModel *dataModel in model.data) {
                [_dataArray addObject:dataModel];
            }
        }else {
            [_dataArray removeAllObjects];
            for (DataModel *dataModel in model.data) {
                [_dataArray addObject:dataModel];
            }
        }
        [_collectionView reloadData];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)createTopView {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width,height(self.view));
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createTwoLayout]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate =self;
    _collectionView.showsHorizontalScrollIndicator =NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellcollId"];
    [self.view addSubview:_collectionView];
    if (_SB == 5) {
        return;
    }
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForDetailNet:NO];
    }];
    _collectionView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForDetailNet:YES];
    }];
    _collectionView.mj_footer = refreshFooter;
            [refreshHeader beginRefreshing];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_SB == 5) {
        if (_dataArray.count > 60) {
            return 60;
        }
        return _dataArray.count;
    }

   return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellcollId" forIndexPath:indexPath];
    cell1.layer.shadowColor = [UIColor grayColor].CGColor;
    cell1.layer.shadowOffset =CGSizeMake(2, 2);
    cell1.layer.shadowRadius = 2;
    cell1.layer.shadowOpacity = 0.5;
    cell1.userInteractionEnabled = YES;
    cell1.delegate = self;
    cell1.downLoaddelegate = self;
    cell1.backgroundColor = [UIColor whiteColor];
    if (_SB == 5) {
        [cell1 setModel:_dataArray[indexPath.row] With:100000];
    }
    [cell1 setModel:_dataArray[indexPath.row]With:indexPath.row];
    return cell1;
   
}
- (UICollectionViewLayout *)createTwoLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-24)/2,(width(self.view)-24)*16/26);
    layout.sectionInset = UIEdgeInsetsMake(7,7,5,7);
//    layout.headerReferenceSize = CGSizeMake(0, 0);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    layout.sectionHeadersPinToVisibleBounds = NO;
    return layout;
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
