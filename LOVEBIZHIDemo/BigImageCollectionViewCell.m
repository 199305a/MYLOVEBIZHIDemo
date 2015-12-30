//
//  BigImageCollectionViewCell.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/18.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "BigImageCollectionViewCell.h"
#import <UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "DetailViewController.h"
#define Random arc4random()%256/255.0
@interface BigImageCollectionViewCell (){
    UIImageView *_imageVeiw;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
}
@end
@implementation BigImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageVeiw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20,width(self.contentView),width(self.contentView)*8/9)];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, maxY(_imageVeiw)+40, width(self.contentView), 1)];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:label];
        UIImage *image = [[UIImage imageNamed:@"list_download"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview1 = [[UIImageView alloc]initWithImage:image];
        UIImage *image1 = [[UIImage imageNamed:@"list_heart"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview2 = [[UIImageView alloc]initWithImage:image1];
        UIImage *image2 = [[UIImage imageNamed:@"preview_shares"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview3 = [[UIImageView alloc]initWithImage:image2];
        UIImage *image3 = [[UIImage imageNamed:@"preview_puzzles"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview4 = [[UIImageView alloc]initWithImage:image3];
        CGFloat padding = 5;
        imageview1.frame = CGRectMake(5, maxY(_imageVeiw)+2*padding, 20, 20);
        imageview2.frame = CGRectMake(70,maxY(_imageVeiw)+2*padding, 20, 20);
        imageview3.frame = CGRectMake(140,maxY(_imageVeiw)+2*padding, 20, 20);
        imageview4.frame = CGRectMake(200,maxY(_imageVeiw)+2*padding, 20, 20);
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageview1)+padding/2, maxY(_imageVeiw)+padding,45, 30)];
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageview2)+padding/2, maxY(_imageVeiw)+padding,50, 30)];
        _label3 = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageview3)+padding/2, maxY(_imageVeiw)+padding,40, 30)];
        _label4 = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageview4)+padding/2, maxY(_imageVeiw)+padding,40, 30)];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label2.textAlignment = NSTextAlignmentCenter;
        _label3.textAlignment = NSTextAlignmentCenter;
        _label4.textAlignment = NSTextAlignmentCenter;
        _label1.textColor = [UIColor grayColor];
        _label2.textColor = [UIColor grayColor];
        _label3.textColor = [UIColor grayColor];
        _label4.textColor = [UIColor grayColor];
        UILabel *label5 =[[UILabel alloc]initWithFrame:CGRectMake(20, maxY(_imageVeiw)+50, width(self.contentView)-20, 20)];
        label5.font = [UIFont systemFontOfSize:15];
        label5.text = @"点击查看更多相关壁纸 :";
        [self.contentView addSubview:imageview1];
        [self.contentView addSubview:imageview2];
        [self.contentView addSubview:imageview3];
        [self.contentView addSubview:imageview4];
        [self.contentView addSubview:_imageVeiw];
        [self.contentView addSubview:_label1];
        [self.contentView addSubview:_label2];
        [self.contentView addSubview:_label3];
        [self.contentView addSubview:_label4];
        [self.contentView addSubview:label5];
    }
    return self;
}
- (void)setModelWithData:(DataModel *)dataModel{
    DataModel*model = dataModel;
     NSArray *arr = [NSArray arrayWithArray:model.tags];
    [_imageVeiw sd_setImageWithURL:[NSURL URLWithString:model.image.big] placeholderImage:nil];
    _imageVeiw.clipsToBounds = YES;
    _label1.text = model.counts.down;
    _label2.text = model.counts.loved;
    _label3.text = model.counts.share;
    _label4.text = model.counts.puzzle;
    for (UIView *view in [self.contentView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag > 10000) {
                [view removeFromSuperview];
            }
        }
    }
    CGFloat w = 0;
    CGFloat h = 0;
    for (NSInteger i =0; i < arr.count; i++) {
        TagsModel *togModel = arr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 10001 + i;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [togModel.name boundingRectWithSize:CGSizeMake(width(self.contentView), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        //        button.backgroundColor = [UIColor yellowColor];
        button.layer.cornerRadius = 5;
        //设置边框宽度
        button.layer.borderWidth = 1;
        //设置边框颜色
        button.clipsToBounds = YES;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        button.backgroundColor = [UIColor colorWithRed:Random green:Random blue:Random alpha:1.0];
        [button setTitle:togModel.name forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.frame = CGRectMake(18 + w,h + maxY(_imageVeiw)+75,length + 20 , 30);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        w = button.frame.size.width + button.frame.origin.x;
        if (15 + w +length + 30 > width(self.contentView) - length) {
            w = 0;
            h = h + height(button) + 8 ;
        }
        [self.contentView addSubview:button];
    }
}
- (void)clickButton:(UIButton *)button {
    if (_delegate) {
        [_delegate popToDetailView:button.titleLabel.text];
    }
}

@end
