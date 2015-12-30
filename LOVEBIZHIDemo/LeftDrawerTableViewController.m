//
//  LeftDrawerTableViewController.m
//  LOVEbizhi
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "LeftDrawerTableViewController.h"
#import "SearchViewController.h"
#import "BaseViewController.h"
#import "SetViewController.h"
#import "RootNavigationController.h"
#import "MessageViewController.h"
#import "AboutViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "AppDelegate.h"
#import "FristViewController.h"
#import "UIView+Common.h"
#import "DetailViewController.h"
#import "DBManager.h"
@interface LeftDrawerTableViewController ()<UITableViewDataSource,UITableViewDelegate,FristViewControllerDelagate>
{
    NSArray *_dataArray;
    UITableView *_tabeliew;
    UIImageView * imageview;
    NSArray *_imageArray;
}
@property (nonatomic,strong) RootNavigationController *showNavController;

@end

@implementation LeftDrawerTableViewController
- (void)createButtonAction:(FristViewController *)bvc {
    [self createView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createimageview];
    _dataArray = @[@"搜索",@"首页",@"消息",@"设置",@"关于"];
    _imageArray = @[@"search@2x",@"home@2x",@"message@2x",@"setting@2x",@"about@2x"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    _tabeliew = [[UITableView alloc]initWithFrame:CGRectMake(0,64,200,300)];
    _tabeliew.dataSource = self;
    _tabeliew.delegate = self;
    _tabeliew.backgroundColor = [UIColor clearColor];
    [_tabeliew setSeparatorColor:[UIColor whiteColor]];
    [imageview addSubview:_tabeliew];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)createimageview {
    imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_back"]];
    
    imageview.userInteractionEnabled = YES;
    
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    imageview.frame = CGRectMake(0, 64,width(self.view),height(self.view));
    
    [self.view addSubview:imageview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indenter = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenter];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenter];
    }
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [self createView];
           
        }
            break;
        case 1:{
            FristViewController *fristVc= [FristViewController new];
            RootNavigationController *rootNac = [[RootNavigationController alloc] initWithRootViewController:fristVc];
            fristVc.delegate = self;
            fristVc.title = @"首页";
            [self.mm_drawerController setCenterViewController:rootNac];
        }
            break;
        case 2:
        {
            self.view.backgroundColor = [UIColor whiteColor];
            NSMutableArray *dataSoucre = [NSMutableArray arrayWithArray:[[DBManager sharedManager] readModels]];
                DetailViewController *dvc = [[DetailViewController alloc]init];
            [dvc setModelWithShoucang:dataSoucre];
            RootNavigationController *rootNac = [[RootNavigationController alloc] initWithRootViewController:dvc];
            dvc.title = @"收藏";
            [self.mm_drawerController setCenterViewController:rootNac];
        }
            break;
        case 3:{
            SetViewController *setVc =[SetViewController new];
            RootNavigationController *rootNac = [[RootNavigationController alloc] initWithRootViewController:setVc];
            setVc.title = @"设置";
            [self.mm_drawerController setCenterViewController:rootNac];
        }
            break;
        case 4:{
            AboutViewController *aboutVc = [AboutViewController new];
            RootNavigationController *rootNac = [[RootNavigationController alloc] initWithRootViewController:aboutVc];
            aboutVc.title = @"关于";
            [self.mm_drawerController setCenterViewController:rootNac];
        }
            break;
        default:
            break;
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)createView {
    SearchViewController *searchVc= [SearchViewController new];
    searchVc.title = @"搜索";
    RootNavigationController *rootNac = [[RootNavigationController alloc] initWithRootViewController:searchVc];
    
    [self.mm_drawerController setCenterViewController:rootNac];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
