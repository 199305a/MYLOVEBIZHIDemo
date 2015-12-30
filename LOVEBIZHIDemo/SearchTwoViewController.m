 //
//  SearchTwoViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/17.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "SearchTwoViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "FristCollectionViewCell.h"
#import "DetailViewController.h"
#import <MBProgressHUD.h>
#import "NSString+Tools.h"
#import "JWCache.h"
@interface SearchTwoViewController ()<UISearchBarDelegate,UICollectionViewDataSource, UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,downLoadButtonDelegate>
{
    NSString *_string;
UISearchBar *_searchBar;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataSouce;
    UITableView *_tableVeiw;
    UICollectionView *_collectionView;
    UIView *_topView;
    UIButton *_button;
    NSArray *_collerArray;
    UILabel *_label;
    UILabel *_downlabel;
}
@end

@implementation SearchTwoViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
//self.navigationItem.leftBarButtonItem.title = @"爱壁纸";
    [self createSearchBar];
    [self createTableView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, width(self.view), height(self.view)-108)];
    [self.view addSubview:_label];
    _downlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_downlabel];

    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)createTopView {
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width,(width(self.view)-24)*16/26+5);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createTwoLayout]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.contentSize = CGSizeMake(width(self.view),(width(self.view)-24)*16/26);
    _collectionView.showsHorizontalScrollIndicator =NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[FristCollectionViewCell class] forCellWithReuseIdentifier:@"cellcollId"];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width(self.view), (width(self.view)-24)*16/26+80)];
    _button = [[UIButton alloc]initWithFrame:CGRectMake(80, maxY(_collectionView)+12, width(self.view)- 160, 50)];
    _button.backgroundColor = [UIColor redColor];
    _button.layer.cornerRadius = 5;
    _topView.backgroundColor = [UIColor whiteColor];
//    [NSString stringWithFormat:@"查看 %@ 全部壁纸",_string];
    [_button setTitle:[NSString stringWithFormat:@"查看 %@ 全部壁纸",_string] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    _button.layer.shadowColor = [UIColor grayColor].CGColor;
    _button.layer.shadowOffset =CGSizeMake(3, 3);
    _button.layer.shadowRadius = 4;
    _button.layer.shadowOpacity = 0.7;
    _button.userInteractionEnabled = YES;
    _button.titleLabel.font = [UIFont systemFontOfSize:20];
    [_button setTintColor:[UIColor whiteColor]];
    _topView.userInteractionEnabled = YES;
    [_topView addSubview:_collectionView];
    [_topView addSubview:_button];
    _tableVeiw.tableHeaderView.userInteractionEnabled = YES;
    _tableVeiw.tableHeaderView=_topView;
//    _collerArray = [NSMutableArray new];
//    _collerArray = @[_dataSouce[0],_dataSouce[1]];
}
- (void)clickbutton:(UIButton *)button {
//    button.titleLabel.text
    DetailViewController *dvc= [[DetailViewController alloc]init];
    [dvc setModelWith:_string];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (UICollectionViewLayout *)createTwoLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 7;
    layout.itemSize = CGSizeMake((width(self.view)-24)/2,(width(self.view)-24)*16/26);
    layout.sectionInset = UIEdgeInsetsMake(2,7,5,7);
    
    //layout.headerReferenceSize = CGSizeMake(50, ((width(self.view)-20)/8+10)*5);
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    return layout;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FristCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellcollId" forIndexPath:indexPath];
    cell1.layer.shadowColor = [UIColor grayColor].CGColor;
    cell1.layer.shadowOffset =CGSizeMake(2, 2);
    cell1.layer.shadowRadius = 2;
    cell1.layer.shadowOpacity = 0.5;
    cell1.userInteractionEnabled = YES;
    cell1.downLoaddelegate = self;
    cell1.backgroundColor = [UIColor whiteColor];
    [cell1 setModel:_dataSouce[indexPath.row]With:indexPath.row];
    return cell1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataSouce.count == 1) {
        return 1;
    }
    return 2;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        _string = searchBar.text;
        _topView = nil;
    }
    [self createDataWith:_string];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        _string = searchBar.text;
        _topView = nil;
    }
    [self createDataWith:_string];
    [searchBar resignFirstResponder];
}
- (void)createTableView {
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, width(self.view), height(self.view)-108)];
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
//    _tableVeiw.contentSize = self.view.frame.size;
    [self.view addSubview:_tableVeiw];
}
- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, width(self.view), 44)];
    _searchBar.barStyle =  UIBarStyleDefault ;
    _searchBar.delegate = self;
    _searchBar.text = _string;
    _searchBar.showsCancelButton = YES;
    [self.view addSubview:_searchBar];
    for (UIView *obj in [_searchBar.subviews[0] subviews]) {
        if ([obj isKindOfClass:NSClassFromString(@"UISearchBarTextField")] || [obj isKindOfClass:[UITextField class]]) {
            UITextField *textF = (UITextField *)obj;
            textF.clipsToBounds = NO;
            textF.leftView = nil;
            textF.borderStyle = UITextBorderStyleRoundedRect;
            textF.clearButtonMode = UITextFieldViewModeAlways;
            
        }
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *but = (UIButton *)obj;
            but.frame = CGRectMake(0, 0, 20, 44);
            //            but.backgroundColor= [UIColor yellowColor];
            UIImage *image = [[UIImage imageNamed:@"abs__ic_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [but setImage:image forState:UIControlStateNormal ];
            but.imageEdgeInsets = UIEdgeInsetsMake(0,6, 0,6);
            [but setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (void)setModelWithstring:(NSString *)string{
    _string = string;
    [self createDataWith:_string];
//
}
- (void)createDataWith:(NSString *)string {
  NSString *url = [NSString stringWithFormat:SearchUrl,string];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _dataArray = [NSMutableArray new];
     _dataSouce = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:
     self.view animated:YES];
//    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
//    if (cacheData) {
//        FristModel *model = [[FristModel alloc]initWithData:cacheData error:nil];
//        
//        
//        for (TagsModel *tagModel in model.tags) {
//            [_dataArray addObject:tagModel];
//        }
//        for (DataModel *dataModel in model.data) {
//            [_dataSouce addObject:dataModel];
//        }
//        if (_dataArray.count > 0 ) {
//            if (_topView == nil) {
//                [self createTopView];
//            }
//            [_tableVeiw reloadData];
//            _label.frame = CGRectMake(0, 0, 0, 0);
//        }else{
//            _label.text = [NSString stringWithFormat:@"没有找到 %@ 的结果",_string];
//            _label.frame = CGRectMake(0, 108, width(self.view), height(self.view)-108);
//            return ;
//        }
    
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        return;
//    }
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FristModel *model = [[FristModel alloc]initWithData:responseObject error:nil];
   
        
        for (TagsModel *tagModel in model.tags) {
            [_dataArray addObject:tagModel];
        }
        for (DataModel *dataModel in model.data) {
            [_dataSouce addObject:dataModel];
        }
        if (_dataArray.count > 0 ) {
            if (_topView == nil) {
                [self createTopView];
            }
            [_tableVeiw reloadData];
            _label.frame = CGRectMake(0, 0, 0, 0);
        }else{
        _label.text = [NSString stringWithFormat:@"没有找到 %@ 的结果",_string];
            _label.frame = CGRectMake(0, 108, width(self.view), height(self.view)-108);
            return ;
        }
        
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [JWCache setObject:responseObject forKey:MD5Hash(url)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenter = @"celldId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenter];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenter];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (_dataArray.count > 0) {
        TagsModel *model =_dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.total];
    }
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset =CGSizeMake(1, 0);
    cell.layer.shadowRadius = 2;
    cell.layer.shadowOpacity = 0.5;
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [[DetailViewController alloc]init];
    if (_dataArray.count > 0) {
        TagsModel *model =_dataArray[indexPath.row];
        [dvc setModelWith1:model.name AndString:model.tid];
    }
    [self.navigationController pushViewController:dvc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat widths = (width(self.view)-24)*16/26+80;
    return  0;
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
