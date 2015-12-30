//
//  SearchViewController.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "SearchViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FristModel.h"
#import "UIView+Common.h"
#import "SearchTwoViewController.h"
#import "DetailViewController.h"
#import "NSString+Tools.h"
#import "JWCache.h"
#import <MBProgressHUD.h>
@interface SearchViewController ()<UISearchBarDelegate>{
    NSMutableArray *_dataArray;
    UISearchBar *_searchBar;
    NSMutableArray *_dataArray1;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationButton];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *_label = [[UILabel alloc]initWithFrame:CGRectMake(10,110,width(self.view)-10, 30)];
    _label.font = [UIFont boldSystemFontOfSize:22];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.text = @"热门标签";
    [self.view addSubview:_label];
    [self createView];
    [self createSearchBar];
    // Do any additional setup after loading the view.
}
- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, width(self.view), 44)];
    _searchBar.placeholder = @"请输入“关键字”或“壁纸编号”";
    _searchBar.barStyle =  UIBarStyleDefault ;
    _searchBar.delegate = self;
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
            UIImage *image = [[UIImage imageNamed:@"btn_nav_search@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [but setImage:image forState:UIControlStateNormal ];
            but.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0,0);
            [but setTitle:@"" forState:UIControlStateNormal];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        [self createSearchWith:searchBar.text];
        [searchBar resignFirstResponder];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [self createSearchWith:searchBar.text];
        [searchBar resignFirstResponder];
    }
}
- (void)createSearchWith:(NSString*)string {
    SearchTwoViewController *secTwoVc = [[SearchTwoViewController alloc]init];
    [secTwoVc setModelWithstring:_searchBar.text];
    [self.navigationController pushViewController:secTwoVc animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}
- (void)createView {
    _dataArray = [NSMutableArray new];
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    NSString *url = SearchHomeUrl;
    _dataArray1 =[NSMutableArray new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
//    if (cacheData) {
//        _dataArray1 = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
//        for (NSDictionary *dic in _dataArray1) {
//            TagsModel *tagmodel = [[TagsModel alloc]initWithDictionary:dic error:nil];
//            [_dataArray addObject:tagmodel];
//        }
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [self createButton];
//        return;
//    }

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _dataArray1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in _dataArray1) {
            TagsModel *tagmodel = [[TagsModel alloc]initWithDictionary:dic error:nil];
            [_dataArray addObject:tagmodel];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self createButton];
//        [JWCache setObject:responseObject forKey:MD5Hash(url)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
 
}
- (void)createButton {
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag > 10000) {
                [view removeFromSuperview];
            }
        }
    }
    CGFloat w = 0;
    CGFloat h = 150;
    for (NSInteger i =0; i < _dataArray.count; i++) {
        TagsModel *togModel = _dataArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 10001 + i;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [togModel.name boundingRectWithSize:CGSizeMake(width(self.view), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        button.layer.cornerRadius = 5;
        //设置边框宽度
        button.layer.borderWidth = 1;
        //设置边框颜色
        button.layer.borderColor = [[UIColor grayColor] CGColor];
//        button.layer.shadowColor = [UIColor grayColor].CGColor;
//        button.layer.shadowOffset =CGSizeMake(3, 3);
//        button.layer.shadowRadius = 4;
//        button.layer.shadowOpacity = 0.7;
//        button.userInteractionEnabled = YES;
        //允许剪切边界
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:togModel.name forState:UIControlStateNormal];
        button.tintColor = [UIColor grayColor];
        button.frame = CGRectMake(18 + w,h,length + 30 , 40);
        w = button.frame.size.width + button.frame.origin.x;
        if (15 + w +length + 30 > width(self.view) - length) {
            w = 0;
            h = h + height(button) + 10 ;
        }
        [self.view addSubview:button];
    }

}
- (void)clickButton:(UIButton *)button {
    DetailViewController *dvc =[[DetailViewController alloc]init];
    [dvc setModelWith:button.titleLabel.text];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)createNavigationButton {
    UIImage *image1 =[[UIImage imageNamed:@"abs__ic_menu_moreoverflow_normal_holo_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 =[[UIImage imageNamed:@"oauth_refrash"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(clearSearch)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(refreshView)];
    item.imageInsets = UIEdgeInsetsMake(4, 5, 4, 5);
     item2.imageInsets = UIEdgeInsetsMake(0,10, 0,-10);
    self.navigationItem.rightBarButtonItems = @[item,item2];
}
- (void)refreshView {
    [_dataArray removeAllObjects];
    [self createView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clearSearch {

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
