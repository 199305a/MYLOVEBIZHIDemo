//
//  FristCollectionViewCell.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/16.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "FristCollectionViewCell.h"
#import "UIView+Common.h"
#import <UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BigImageViewController.h"
#import "DBManager.h"
#define  Random arc4random()%256/255.0
@interface FristCollectionViewCell (){
    UIImageView *_imageView;
    UIButton *_loveButton;
    UIButton *_downButton;
    NSArray *_arr;
    DataModel *_model;
    UILabel *_label;
    NSString *_data4;
    NSInteger *_row;
}

@end
@implementation FristCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
//宽 260 高  320
//图片 260 230
//按钮 40   50
- (void)createView {
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,width(self.contentView),width(self.contentView)*24/26)];
    //_imageView.backgroundColor = [UIColor greenColor];
    _loveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height(self.contentView)*28/32, width(self.contentView)/2, height(self.contentView)*4/32)];
    //_loveButton.backgroundColor = [UIColor yellowColor];
    _downButton = [[UIButton alloc]initWithFrame:CGRectMake(maxX(_loveButton), minY(_loveButton), width(_loveButton), height(_loveButton))];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,height(self.contentView)*28/32-1, width(self.contentView), 0.8)];
    _imageView.userInteractionEnabled = YES;
    label1.backgroundColor = [UIColor lightGrayColor];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 0.8, height(_loveButton))];
    label2.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_loveButton];
    [self.contentView addSubview:_downButton];
    [self.contentView addSubview:label1];
    [_downButton addSubview:label2];
}
- (void)setModel:(DataModel *)dataModel With:(NSInteger)row{
    _model = dataModel;
    if (_model.tags != nil) {
        _arr = [NSArray arrayWithArray:_model.tags];

    }else {
        _arr = _model.tas1;}
    NSString *data1 = _model.image.small;
    NSString *data2 = _model.counts.loved;
    NSString *data3 = _model.counts.down;
    _data4 = _model.image.big;
    if (_model.image.small == nil) {
        data1 = dataModel.imagesmall;
//        data1 = dataModel.imagebig;
        data2  = dataModel.countsloved;
        data3 = dataModel.countsdown;
        _data4 = dataModel.imagebig;
    }
    NSLog(@"%d",[[DBManager sharedManager]isExistAppForAppId:_model.file_id]);
    //    UIImage *image = [imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _imageView.contentMode = UIViewContentModeCenter;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:data1] placeholderImage:[UIImage imageNamed:@"lms_spinner"]];

    if ([[DBManager sharedManager]isExistAppForAppId:_model.file_id]) {
              UIImage *image =  [[UIImage imageNamed:@"list_heart_red"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [_loveButton setImage:image forState:UIControlStateNormal];
    }else{
        
        [_loveButton setImage:[UIImage imageNamed:@"list_heart"] forState:UIControlStateNormal];
        }
    
    
    [_downButton setImage:[UIImage imageNamed:@"list_download"] forState:UIControlStateNormal];
//    _downButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

    [_loveButton setTitle:data2 forState:UIControlStateNormal];
    [_downButton setTitle:data3 forState:UIControlStateNormal];
    //CGRect frame = CGRectMake(width(_downButton)/2, 0, width(_downButton)/4, height(_downButton));
//    _loveButton.tag = [_model.file_id integerValue]/100;
    [_loveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_downButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   _loveButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
   
    _downButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [_downButton addTarget:self action:@selector(downloadImageWithURL:) forControlEvents:UIControlEventTouchUpInside];
    [_loveButton addTarget:self action:@selector(lovebuttonImageWithURL:) forControlEvents:UIControlEventTouchUpInside];
    [_loveButton setImageEdgeInsets:UIEdgeInsetsMake(2, width(_downButton)/4-10, 2, width(_downButton)/2+8)];
    [_downButton setImageEdgeInsets:UIEdgeInsetsMake(2, width(_downButton)/4-10, 2, width(_downButton)/2+8)];
        
    for (UIView *view in [self.contentView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag > 10000) {
                [view removeFromSuperview];
            }
        }
    }
    CGFloat w = 0;
    for (NSInteger i =0; i < _arr.count; i++) {
        TagsModel *togModel = _arr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 10001 + i;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGFloat length = [togModel.name boundingRectWithSize:CGSizeMake(width(self.contentView), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
//        button.backgroundColor = [UIColor yellowColor];
        [button setTitle:togModel.name forState:UIControlStateNormal];
        button.tintColor = [UIColor colorWithRed:Random green:Random blue:Random alpha:0.8];
        button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        button.frame = CGRectMake(w,maxY(_imageView),length+10 , 25);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        w = button.frame.size.width + button.frame.origin.x;
        [self.contentView addSubview:button];
        self.contentView.clipsToBounds = YES;
}
}
- (void)lovebuttonImageWithURL:(UIButton *)button {
    
    
    if ([[DBManager sharedManager]isExistAppForAppId:_model.file_id]) {
        [[DBManager sharedManager] deleteModelForAppId:_model.file_id];
        [_loveButton setImage:[UIImage imageNamed:@"list_heart"] forState:UIControlStateNormal];
          }else{
              [[DBManager sharedManager] insertModel:_model AppId:_model.file_id];
            UIImage *image =  [[UIImage imageNamed:@"list_heart_red"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [_loveButton setImage:image forState:UIControlStateNormal];}
    

}

- (void)downloadImageWithURL:(UIButton *)button {
    NSLog(@"一下");
    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:_data4] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImageWriteToSavedPhotosAlbum(image , self, @selector(image1:didFinishSavingWithError:contextInfo:), nil);
        NSLog(@"一+下");
    }];
    
}
- (void)image1:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"两下");
    if (error) {
        NSLog(@"图像保存失败");
    }else {
        NSLog(@"图像保存成功");
        
    }
    if (_downLoaddelegate) {
        [_downLoaddelegate popToDetailViewwithError:error];
    }
    _downButton.selected = YES;
    [UIView animateWithDuration:3 animations:^{
        
    } completion:^(BOOL finished) {
        _downButton.selected = NO;
    }];
}

- (void)clickButton:(UIButton *)button {
    if (_delegate) {
        [_delegate popToDetailView:button.titleLabel.text];
    }
}
@end
