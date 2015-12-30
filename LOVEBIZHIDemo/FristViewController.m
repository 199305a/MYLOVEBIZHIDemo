//
//  FristViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "FristViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FristCollectionViewCell.h"
#import "UIView+Common.h"
#import "FristModel.h"
#import <UIImage+WebP.h>
#import "SecondCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "ZTDetailViewController.h"
#import "ZTViewController.h"
//彩铃
#import "LSTableViewCell.h"
//排行
#import "PHViewController.h"
//大图
#import "BigImageViewController.h"
#import "LLDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
//专题
#import "LLDetailViewController.h"
#import "JWCache.h"
#import "NSString+Tools.h"
#import <MBProgressHUD.h>
#define  Random arc4random()%256/255.0

@interface FristViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ButtonDelegate,UITableViewDataSource,UITableViewDelegate,downLoadButtonDelegate>
{
    UIScrollView *_bigScrollView;
    UICollectionView *_collectionView;
    UIScrollView *_scrollView;
    CGFloat _screenWidth;
    NSArray *_nameArray;
    UIButton *_button;
    UILabel *_Label;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    UIScrollView *_hxscrollView;
    UIPageControl *_pageControl;
    UICollectionView *_SecondcollectionView;
    UIView *_buttonView;
    //第二页数据
    NSMutableArray *_dataTwoArray;
    NSMutableArray *_dataTwoArray1;
    NSString *_url;
    NSTimer *_timer;
    NSInteger time;
    UITableView *_lsTableView;
    NSMutableArray *_lsdataArray;
    UILabel *_downlabel;
}
@end

@implementation FristViewController
- (void)popToDetailView:(NSString *)string{
    DetailViewController *tvc =[[DetailViewController alloc]init];
    [tvc setModelWith:string];
    [self.navigationController pushViewController:tvc animated:YES];
}
//- (void)popToDetailView1:(NSString *)string {
////    BigImageViewController *bvc= [[BigImageViewController alloc]init
////                                  ];
////    [bvc setModelWith:string];
////    [self.navigationController pushViewController:bvc animated:YES];
//}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.userInteractionEnabled = YES;
    [self createBigScrollView];
    [self createScrollView];
    [self addButton];
    [self createTwoData];
    [self createButton];
    [self createCollectionView];
    [self createScorlViewimage];
    [self createTableView];
    _downlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_downlabel];
    _dataArray = [NSMutableArray new];
    _dataArray1 = [NSMutableArray new];
//    self.navigationItem.title = @"首页";
//    UINavigationBar * navigationBar = [UINavigationBar appearance];
//    [navigationBar setTintColor:[UIColor whiteColor]];
//    [self creatrPage];
    // Do any additional setup after loading the view.
}
- (void)createTableView {
    _lsTableView = [[UITableView alloc]initWithFrame:CGRectMake(width(self.view)*2,0, self.view.frame.size.width,height(_bigScrollView))];
    _lsTableView.delegate = self;
    _lsTableView.dataSource = self;
    _lsdataArray = [NSMutableArray new];
    [_bigScrollView addSubview:_lsTableView];
    _lsTableView.backgroundColor = [UIColor whiteColor];
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForNetls:NO];
    }];
    _lsTableView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNetls:YES];
    }];
    _lsTableView.mj_footer = refreshFooter;
    [refreshHeader beginRefreshing];
    
}
//铃声请求
- (void)loadDataForNetls:(BOOL)isMore {
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray.count%15 != 0) {
            return;
        }
        page = _dataArray.count/15 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    NSString *string = [NSString stringWithFormat:LSURL,page];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(string)];
    if (cacheData) {
        
        LSModel *lsmodel = [[LSModel alloc]initWithData:cacheData error:nil];
        
        NSDictionary *lsdmodel = lsmodel.model;
        ;
        if (isMore) {
            for (ListModel *llmodel in lsdmodel[@"list"]) {
                [_lsdataArray addObject:llmodel];
            }

        }else{
            [_lsdataArray removeAllObjects];
            for (ListModel *llmodel in lsdmodel[@"list"]) {
                [_lsdataArray addObject:llmodel];
            }
        }
                [_lsTableView reloadData];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_lsTableView.mj_footer endRefreshing]:[_lsTableView.mj_header endRefreshing];
        return;
    }

//    NSString *url = [LSURL stringByAppendingString:string];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        SecondModel *model = [[SecondModel alloc]initWithData:responseObject error:nil];
//        for (DatasModel *dataModel in model.data) {
//            [_dataArray addObject:dataModel];
//        }
//
        LSModel *lsmodel = [[LSModel alloc]initWithData:responseObject error:nil];
        
        NSDictionary *lsdmodel = lsmodel.model;
               ;
        for (ListModel *llmodel in lsdmodel[@"list"]) {
            [_lsdataArray addObject:llmodel];
        }
        [_lsTableView reloadData];
        isMore?[_lsTableView.mj_footer endRefreshing]:[_lsTableView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(string)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isMore?[_lsTableView.mj_footer endRefreshing]:[_lsTableView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lsdataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenter = @"lscellId";
    LSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenter];
    if (cell == nil) {
        cell = [[LSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenter];
    }
    [cell setModelWithLsmodel:_lsdataArray[indexPath.row] Andindex:indexPath.row];
    return cell;
}
- (void)createButton {
    UIImage *image = [[UIImage imageNamed:@"btn_nav_search@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clickButton)];
}
- (void)clickButton {
    if (_delegate) {
        [_delegate createButtonAction:self];
    }
}
- (void)creatrPage {
    _pageControl.numberOfPages = _dataArray.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //    [_pageControl addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    [_collectionView addSubview:_pageControl];
}
- (void)createTwoData {
    _dataTwoArray = [NSMutableArray new];
    _dataTwoArray1 = [NSMutableArray new];
    NSString * url = LInkUrl;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        _dataTwoArray = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary*dic in _dataTwoArray) {
            TagsModel *model = [[TagsModel alloc]initWithDictionary:dic error:nil];
            [_dataTwoArray1 addObject:model];
        }
        //        NSLog(@"%@",_dataTwoArray1);
        [self createSecondView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _dataTwoArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary*dic in _dataTwoArray) {
            TagsModel *model = [[TagsModel alloc]initWithDictionary:dic error:nil];
            [_dataTwoArray1 addObject:model];
        }
//        NSLog(@"%@",_dataTwoArray1);
        [self createSecondView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(url)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changecontentSize) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    
}
- (void)changecontentSize {
    time++;
    double x =  labs(time) ;
//    [_hxscrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*x, 0) animated:YES];
    if (time == _dataArray.count - 1) {
        time = - time;
    }
    _pageControl.currentPage = _hxscrollView.contentOffset.x/_hxscrollView.frame.size.width;
}

#pragma mark --请求数据
- (void)loadDataForNet:(BOOL)isMore {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray1.count%60 != 0) {
            return;
        }
        page = _dataArray1.count/60 + 1;
//        [_collectionView.mj_footer endRefreshing];
    }
    
    _url = [NSString stringWithFormat:HomeUrl,page];
//    NSLog(@"%ld",page);
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_url)];
    if (cacheData) {
        FristModel *fristModel = [[FristModel alloc]initWithData:cacheData error:nil];
        [_dataArray removeAllObjects];
        for (SliderModel *sliderModel in fristModel.slider) {
            [_dataArray addObject:sliderModel];
        }
        if (isMore) {
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray1 addObject:dataModel];
            }
        }else {
            [_dataArray1 removeAllObjects];
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray1 addObject:dataModel];
            }
        }
        [_collectionView reloadData];
        [self createScorlView1];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FristModel *fristModel = [[FristModel alloc]initWithData:responseObject error:nil];
        [_dataArray removeAllObjects];
        for (SliderModel *sliderModel in fristModel.slider) {
            [_dataArray addObject:sliderModel];
        }
        if (isMore) {
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray1 addObject:dataModel];
            }
        }else {
            [_dataArray1 removeAllObjects];
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray1 addObject:dataModel];
            }
        }
        
        [_collectionView reloadData];
            [self createScorlView1];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(_url)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *view = nil;
    if (collectionView == _collectionView) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
//            view.backgroundColor = [UIColor greenColor];
            
        }
        if (_hxscrollView == nil) {
            [self createScorlView1];
        }
        _hxscrollView.showsHorizontalScrollIndicator = NO;
        _hxscrollView.bounces = NO;
        [view addSubview:_hxscrollView];

    }else if (collectionView == _SecondcollectionView){
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerTwoId" forIndexPath:indexPath];
            view.backgroundColor = [UIColor colorWithRed:RANCOLOR green:RANCOLOR blue:RANCOLOR alpha:1.0];
            if (_buttonView == nil) {
               [self createButtonView];
            }
        }
    [view addSubview:_buttonView];
    }
    view.userInteractionEnabled = YES;
    return view;
}
//第二也横向 button
- (void)createButtonView {
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width(self.view), ((width(self.view)-20)/8+10)*5)];
    _buttonView.userInteractionEnabled = YES;
//   ((width(self.view)-20)/8+10)*5
    NSArray *namearray = @[@"壁纸专题",@"每日更新",@"排行榜",@"图文并茂",@"热门收藏",@"拼图游戏",@"猜你喜欢",@"试试手气",@"用户分享",@"用户排行"];
    NSArray *imageArray = @[@"zhuanti@2x",@"meiri@2x",@"paihang@2x",@"image_text@2x",@"shoucang@2x",@"puzzle_game@2x",@"caini@2x",@"shouqi@2x",@"upload_list@2x",@"upload_user@2x"];
    for (NSInteger i = 0; i < 5 ; i++) {
        for (NSInteger j = 0; j < 2 ; j++) {
            CGFloat padding = 5 ;
            CGFloat lineing = 10 ;
            UIButton *button  =[[UIButton alloc]initWithFrame:CGRectMake(padding+j*(width(self.view))/2,lineing+((width(self.view)-2*lineing)/8+lineing)*i, (width(self.view)-2*lineing)/2,(width(self.view)-2*lineing)/8)];
            [button setTitle:namearray[i*2+j] forState:UIControlStateNormal];
            button.tag = 1000+i*2+j;
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            [button setImage:[UIImage imageNamed:imageArray[i*2+j]] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:Random green:Random blue:Random alpha:1.0];
            button.imageEdgeInsets = UIEdgeInsetsMake(2,5, 2,90);
            [button  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(popToLLDetailView:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.shadowColor = [UIColor grayColor].CGColor;
            button.layer.shadowOffset =CGSizeMake(2, 2);
            button.layer.shadowRadius = 2;
            button.layer.shadowOpacity = 0.5;
            button.userInteractionEnabled = YES;

//            button.backgroundColor = [UIColor whiteColor];
            [_buttonView addSubview:button];
        }
    }
}
- (void)popToLLDetailView:(UIButton *)button {
    switch (button.tag) {
        case 1000:
       {
           ZTViewController *zvc = [[ZTViewController alloc]init];
           [self.navigationController pushViewController:zvc animated:YES];
    }
            break;
        case 1001:{
            
            DetailViewController *dvc = [[DetailViewController alloc]init];
            [dvc setModelWithFenxiang:nil];
            [self.navigationController pushViewController:dvc animated:YES];

        }
            break;
        case 1002:{
            PHViewController *pvc = [[PHViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1003:{
            BigImageViewController *bvc = [[BigImageViewController alloc]init];
            [bvc setModelWith:0 AndData:TWURl];
            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;

        case 1004:
        {
            PHViewController *pvc = [[PHViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1005:{
            PHViewController *pvc = [[PHViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1006:{
            DetailViewController *dvc = [[DetailViewController alloc]init];
            [dvc setModalWithcaini];
            [self.navigationController pushViewController:dvc animated:YES];        }
            break;
        case 1007:{
            DetailViewController *dvc = [[DetailViewController alloc]init];
            [dvc setModalWithShouqi];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;

        case 1008:
        {
            DetailViewController *dvc = [[DetailViewController alloc]init];
            [dvc setModelWithFenxiang:nil];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 1009:{
            PHViewController *pvc = [[PHViewController alloc]init];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;

        default:
            break;
    }}
- (void)createScorlViewimage{
    _hxscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width(self.view),height(self.view)*23/100+5)];
    _hxscrollView.pagingEnabled = YES;
    _hxscrollView.delegate = self;
    _hxscrollView.layer.shadowColor = [UIColor grayColor].CGColor;
    _hxscrollView.layer.shadowOffset =CGSizeMake(3, 3);
    _hxscrollView.layer.shadowRadius = 4;
    _hxscrollView.layer.shadowOpacity = 0.7;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(width(self.view)-50,height(_hxscrollView)-10,40,2)];
}
//第一页横向图片浏览器
- (void)createScorlView1 {
//    for (UIView *view in [_hxscrollView subviews]) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            if (view.tag > 1000) {
//                [view removeFromSuperview];
//            }
//        }
//    }
    for (NSInteger i = 0 ;i < _dataArray.count ; i++) {
        SliderModel *slidermodel = _dataArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+width(self.view)*i,0 , self.view.frame.size.width, _hxscrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:slidermodel.image] placeholderImage:nil];
        imageView.tag =1001 + i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicktopic:)];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [_hxscrollView addSubview:imageView];
        [imageView addGestureRecognizer:tap];
    }
    _hxscrollView.contentSize = CGSizeMake(width(self.view)*_dataArray.count,height(_hxscrollView));
    [self creatrPage];
}
- (void)clicktopic:(UITapGestureRecognizer *)tgp {
    NSLog(@"点击");
    ZTDetailViewController *ztvc = [[ZTDetailViewController alloc]init];
    SliderModel *model = _dataArray[tgp.view.tag- 1001];
    [ztvc setModelWithstring:model.detail];
    [self.navigationController pushViewController:ztvc animated:YES];
}
- (UICollectionViewLayout *)createTwoLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-35)/3,(width(self.view)-24)/3);
    layout.sectionInset = UIEdgeInsetsMake(7,7,7,7);
    
    layout.headerReferenceSize = CGSizeMake(50, ((width(self.view)-20)/8+10)*5);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    return layout;
}

//创建第二页的竖向滚动视图
- (void)createSecondView {
    CGRect frame = CGRectMake(width(self.view),0, self.view.frame.size.width,height(_bigScrollView));
   _SecondcollectionView  = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createTwoLayout]];
    _SecondcollectionView.backgroundColor = [UIColor colorWithRed:RANCOLOR green:RANCOLOR blue:RANCOLOR alpha:1.0];
    _SecondcollectionView.dataSource = self;
    _SecondcollectionView.delegate = self;
    _SecondcollectionView.bounces = NO;
    _SecondcollectionView.userInteractionEnabled = YES;
    [_SecondcollectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"cellTwoId"];
    [_SecondcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerTwoId"];
    [_bigScrollView addSubview:_SecondcollectionView];

}

//创建第一页的竖向滚动视图
- (void)createCollectionView {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width,height(_bigScrollView));
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    _collectionView.backgroundColor = [UIColor colorWithRed:RANCOLOR green:RANCOLOR blue:RANCOLOR alpha:1.0];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.bounces = NO;
    [_collectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [_bigScrollView addSubview:_collectionView];
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForNet:NO];
    }];
    _collectionView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNet:YES];
    }];
    _collectionView.mj_footer = refreshFooter;
    [refreshHeader beginRefreshing];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return _dataArray1.count;
    }
    return _dataTwoArray1.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
   if (collectionView == _SecondcollectionView){
 SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellTwoId" forIndexPath:indexPath];
      
        cell.backgroundColor = [UIColor whiteColor];
    TagsModel *slikeModel = _dataTwoArray1[indexPath.row];
       cell.layer.shadowColor = [UIColor grayColor].CGColor;
       cell.layer.shadowOffset =CGSizeMake(2, 2);
       cell.layer.shadowRadius = 2;
       cell.layer.shadowOpacity = 0.5;
       cell.userInteractionEnabled = YES;
 [cell setTwoModel:slikeModel];
    return cell;
   }
    FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell1.delegate = self;
    cell1.layer.shadowColor = [UIColor grayColor].CGColor;
    cell1.layer.shadowOffset =CGSizeMake(2, 2);
    cell1.layer.shadowRadius = 2;
    cell1.layer.shadowOpacity = 0.5;
    cell1.downLoaddelegate = self;
    cell1.backgroundColor = [UIColor whiteColor];
    cell1.userInteractionEnabled = YES;
    [cell1 setModel:_dataArray1[indexPath.row] With:indexPath.row];
    return cell1;
}

- (UICollectionViewLayout *)createLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-24)/2,(width(self.view)-24)*16/26);
    layout.sectionInset = UIEdgeInsetsMake(10,7,5,7);
    
    layout.headerReferenceSize = CGSizeMake(50, height(self.view)*23/100+5);
//    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    return layout;
}
#pragma mark ---大的横向视图
- (void)addButton {
    _nameArray = @[@"首页",@"浏览",@"彩铃"];
    _screenWidth = self.view.frame.size.width/4;
    for (int i = 0; i < _nameArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_screenWidth*i, 0, _screenWidth, 27);
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(maxX(button)-1, 5,1, maxY(button)-10)];
        [button setTitle:_nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        label.backgroundColor = [UIColor lightGrayColor];
        [_scrollView addSubview:label];
        [_scrollView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            _button = button;
            _button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            _Label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)-1, _screenWidth-1, 4)];
            _Label.backgroundColor = [UIColor purpleColor];
            [_scrollView addSubview:_Label];
        }
    }
    _scrollView.contentSize = CGSizeMake(_screenWidth*_nameArray.count, 30);
    _scrollView.showsHorizontalScrollIndicator = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _bigScrollView) {
        NSInteger index = _bigScrollView.contentOffset.x/self.view.frame.size.width;
        UIButton *button = (UIButton *)[self.view viewWithTag:index+100];
        _button.selected = NO;
        _button.transform = CGAffineTransformMakeScale(1, 1);
        button.selected = YES;
        _button = button;
        _button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    _pageControl.currentPage = _hxscrollView.contentOffset.x/_hxscrollView.frame.size.width;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bigScrollView) {
        [UIView animateWithDuration:0.3 animations:^{
            _Label.frame = CGRectMake(scrollView.contentOffset.x/_bigScrollView.frame.size.width*_screenWidth, CGRectGetMaxY(_button.frame)-1, _screenWidth-1, 4);
        }];
    }
}

- (void)buttonClick:(UIButton *)button {
    if (_button == button) {
        return;
    }
    button.selected = YES;
    _button.selected = NO;
    _button.transform = CGAffineTransformMakeScale(1, 1);
    _button = button;
    _button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.3 animations:^{
        _Label.frame = CGRectMake(CGRectGetMinX(_button.frame), CGRectGetMaxY(_button.frame)-1, _screenWidth-1, 4);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        _bigScrollView.contentOffset = CGPointMake(self.view.frame.size.width*(button.tag-100), 0);
    }];
}
//标题视图
- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,30)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
}
//横向滚动 scrollView
- (void)createBigScrollView {
    _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, self.view.frame.size.height - 94)];
    _bigScrollView.delegate = self;
    _bigScrollView.contentSize = CGSizeMake(3*self.view.frame.size.width, self.view.frame.size.height-94);
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.bounces = NO;
    _bigScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bigScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        BigImageViewController *bvc =[[BigImageViewController alloc]init];
        [self.navigationController pushViewController:bvc animated:YES];
        [bvc setModelWith:indexPath.row AndData:_url];
    }else if (collectionView == _SecondcollectionView){
        LLDetailViewController *lvc =[[LLDetailViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
        SkimModel *model = _dataTwoArray1[indexPath.row];
        [lvc setModelWithLLview:model.url];
    }
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
