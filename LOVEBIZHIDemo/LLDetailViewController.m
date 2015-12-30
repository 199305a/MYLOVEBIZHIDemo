//
//  LLDetailViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/19.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "LLDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FristCollectionViewCell.h"
#import "UIView+Common.h"
#import "FristModel.h"
#import <UIImage+WebP.h>
#import "SecondCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "BigImageViewController.h"
#import "DetailViewController.h"
#import <MJRefresh.h>
#import "NSString+Tools.h"
#import <MBProgressHUD.h>
#import "JWCache.h"
@interface LLDetailViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ButtonDelegate,downLoadButtonDelegate>
{
UIScrollView *_bigScrollView;
    UICollectionView *_collectionView;
    UIScrollView *_scrollView;
    CGFloat _screenWidth;
    NSArray *_nameArray;
    UIButton *_button;
    UILabel *_Label;
     NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
     NSMutableArray *_dataArray3;
    UICollectionView *_SecondcollectionView;
    NSString *_string;
    NSString *_urlstring;
    NSString *_oneString;
    
    UICollectionView *_thridcollectionView;
    NSString *_twoString;
    UILabel *_clearLabel;
    NSString *_urlString;
    UILabel *_downlabel;
}

@end

@implementation LLDetailViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.userInteractionEnabled = YES;
   [self createBigScrollView];
    [self createScrollView];
    [self addButton];
    [self createCollectionView];
    [self createSecondCollectionView];
    [self createThridCollectionView];
    _downlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_downlabel];
    // Do any additional setup after loading the view.
}
- (void)createThridCollectionView {
    CGRect frame = CGRectMake(width(self.view)*2,0, self.view.frame.size.width,height(_bigScrollView));
    _thridcollectionView  = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createThreeLayout]];
    _thridcollectionView.backgroundColor = [UIColor whiteColor];
    _thridcollectionView.dataSource = self;
    _thridcollectionView.delegate = self;
    _thridcollectionView.bounces = NO;
    [_thridcollectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"cellThreeId"];
//    [_thridcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerTwoId"];
    [_bigScrollView addSubview:_thridcollectionView];
    
}
- (UICollectionViewLayout *)createThreeLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-35)/2,(width(self.view)-35)/2);
    layout.sectionInset = UIEdgeInsetsMake(5,7,7,7);
    
//    layout.headerReferenceSize = CGSizeMake(50, ((width(self.view)-20)/8+10)*5);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    return layout;
}

- (void)createCollectionView {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width,height(_bigScrollView));
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.bounces = NO;
    [_collectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [_bigScrollView addSubview:_collectionView];
    _dataArray1 = [NSMutableArray new];
    _dataArray2 = [NSMutableArray new];
    _dataArray3 = [NSMutableArray new];
    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataForNetstring:NO];
    }];
    _collectionView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNetstring:YES];
    }];
    _collectionView.mj_footer = refreshFooter;
    [refreshHeader beginRefreshing];

}
- (void)createSecondCollectionView {
    CGRect frame = CGRectMake(width(self.view),0, self.view.frame.size.width,height(_bigScrollView));
    _SecondcollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    _SecondcollectionView.backgroundColor = [UIColor whiteColor];
    _SecondcollectionView.dataSource = self;
    _SecondcollectionView.delegate = self;
//    _SecondcollectionView.bounces = NO;
    [_SecondcollectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellTwoId"];
    [_bigScrollView addSubview:_SecondcollectionView];
//    MJRefreshNormalHeader *refreshHeader =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadDataForNetsecond:NO];
//    }];
//    _SecondcollectionView.mj_header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataForNetsecond:YES];
    }];
    _SecondcollectionView.mj_footer = refreshFooter;
//    [refreshHeader beginRefreshing];

}

- (UICollectionViewLayout *)createLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-24)/2,(width(self.view)-24)*16/26);
    layout.sectionInset = UIEdgeInsetsMake(5,7,5,7);
    
//    layout.headerReferenceSize = CGSizeMake(50, height(self.view)*23/100+5);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    return layout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return _dataArray1.count;
    }else if (collectionView == _thridcollectionView){
        return  _dataArray3.count;
    }
        return _dataArray2.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collectionView) {
        FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        cell1.delegate = self;
        cell1.downLoaddelegate = self;
        cell1.backgroundColor = [UIColor whiteColor];
        cell1.userInteractionEnabled = YES;
        cell1.layer.shadowColor = [UIColor grayColor].CGColor;
        cell1.layer.shadowOffset =CGSizeMake(2, 2);
        cell1.layer.shadowRadius = 2;
        cell1.layer.shadowOpacity = 0.5;
        cell1.userInteractionEnabled = YES;
        [cell1 setModel:_dataArray1[indexPath.row]With:indexPath.row];
        return cell1;
    }else if (collectionView == _thridcollectionView){
        SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellThreeId" forIndexPath:indexPath];
        cell.layer.shadowColor = [UIColor grayColor].CGColor;
        cell.layer.shadowOffset =CGSizeMake(2, 2);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.5;
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor whiteColor];
        TagsModel *slikeModel = _dataArray3[indexPath.row];
        cell.userInteractionEnabled = YES;
        [cell setTwoModel:slikeModel];
        return cell;
    }
    FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellTwoId" forIndexPath:indexPath];
    cell1.layer.shadowColor = [UIColor grayColor].CGColor;
    cell1.layer.shadowOffset =CGSizeMake(2, 2);
    cell1.layer.shadowRadius = 2;
    cell1.layer.shadowOpacity = 0.5;
    cell1.userInteractionEnabled = YES;
    cell1.delegate = self;
    cell1.downLoaddelegate = self;
    cell1.backgroundColor = [UIColor whiteColor];
    cell1.userInteractionEnabled = YES;
    [cell1 setModel:_dataArray2[indexPath.row]With:indexPath.row];
    return cell1;
}
#pragma mark ---大的横向视图
- (void)addButton {
    _nameArray = @[@"热门",@"最新",@"子分类"];
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
        _clearLabel = [[UILabel alloc]initWithFrame:CGRectMake(width(button)*2, 0, width(button)+1, height(button)+2)];
        _clearLabel.backgroundColor = [UIColor whiteColor];
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
- (void)setModelWithLLview:(NSString *)string{
    _string = string;
//    [self createDataWithString:string];
}
- (void)loadDataForNetstring:(BOOL )isMore{
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray1.count%60 != 0) {
            return;
        }
        page = _dataArray1.count/60 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    NSString *string = [NSString stringWithFormat:@"&p=%d",page];
    _oneString = [_string stringByAppendingString:string];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_oneString)];
    if (cacheData) {
        FristModel *fristModel = [[FristModel alloc]initWithData:cacheData error:nil];
        //        URLModel *urlmodel =[[URLModel alloc]initWithDictionary:fristModel.url error:nil];
        URLModel *urlmodel =fristModel.url;
        //        _urlstring = [NSString stringWithString:urlmodel.newest];
        NSDictionary *cid = urlmodel;
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
        [_dataArray3 removeAllObjects];
        for (TagsModel *tagModel in fristModel.tags) {
            [_dataArray3 addObject:tagModel];
        }
        if (_dataArray3.count == 0) {
            _bigScrollView.contentSize = CGSizeMake(2*self.view.frame.size.width, self.view.frame.size.height-94);
            [_scrollView addSubview:_clearLabel];
        }
        [_collectionView reloadData];
        [_thridcollectionView reloadData];
        if (_urlString == nil) {
            _urlString = cid[@"newest"];
            [self loadDataForNetsecond:NO];
        }
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_oneString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FristModel *fristModel = [[FristModel alloc]initWithData:responseObject error:nil];
//        URLModel *urlmodel =[[URLModel alloc]initWithDictionary:fristModel.url error:nil];
        URLModel *urlmodel =fristModel.url;
//        _urlstring = [NSString stringWithString:urlmodel.newest];
        NSDictionary *cid = urlmodel;
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
        [_dataArray3 removeAllObjects];
        for (TagsModel *tagModel in fristModel.tags) {
            [_dataArray3 addObject:tagModel];
        }
        if (_dataArray3.count == 0) {
    _bigScrollView.contentSize = CGSizeMake(2*self.view.frame.size.width, self.view.frame.size.height-94);
            [_scrollView addSubview:_clearLabel];
        }
        [_collectionView reloadData];
        [_thridcollectionView reloadData];
        if (_urlString == nil) {
            _urlString = cid[@"newest"];
        [self loadDataForNetsecond:NO];
        }
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(_oneString)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)loadDataForNetsecond:(BOOL )isMore {
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray1.count%60 != 0) {
            return;
        }
        page = _dataArray1.count/60 + 1;
        //        [_collectionView.mj_footer endRefreshing];
    }
    NSString *string = [NSString stringWithFormat:@"&p=%d",page];
    _twoString = [_urlString stringByAppendingString:string];
//    _dataArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_twoString)];
    if (cacheData) {
        FristModel *fristModel = [[FristModel alloc]initWithData:cacheData error:nil];
        //        URLModel *urlmodel = fristModel.url;
        //         _urlstring = urlmodel.newest;
        if (isMore) {
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray2 addObject:dataModel];
            }
        }else {
            [_dataArray2 removeAllObjects];
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray2 addObject:dataModel];
            }
        }
        [_SecondcollectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_twoString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FristModel *fristModel = [[FristModel alloc]initWithData:responseObject error:nil];
//        URLModel *urlmodel = fristModel.url;
//         _urlstring = urlmodel.newest;
        if (isMore) {
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray2 addObject:dataModel];
            }
        }else {
            [_dataArray2 removeAllObjects];
            for (DataModel *dataModel in fristModel.data) {
                [_dataArray2 addObject:dataModel];
            }
        }
        [_SecondcollectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(_twoString)];

        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
    }];

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
//标题视图
- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,30)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
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
        [bvc setModelWith:indexPath.row AndData:_oneString];

    }else if (collectionView == _SecondcollectionView){
        BigImageViewController *bvc =[[BigImageViewController alloc]init];
        [self.navigationController pushViewController:bvc animated:YES];
        [bvc setModelWith:indexPath.row AndData:_twoString];
    }else if (collectionView == _thridcollectionView){
        LLDetailViewController *lvc =[[LLDetailViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
        TagsModel *tag = _dataArray3[indexPath.row];
        [lvc setModelWithLLview:tag.url];
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
