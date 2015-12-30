//
//  SecondCollectionViewCell.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/16.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "SecondCollectionViewCell.h"
#import "UIView+Common.h"
#import <UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface SecondCollectionViewCell (){
    UIImageView *_imageView1;
    UILabel *_label;
}
@end
@implementation SecondCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width(self.contentView), height(self.contentView))];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, height(self.contentView)*3/4, width(self.contentView), height(self.contentView)/4)];
        [_imageView1 addSubview:_label];
        [self.contentView addSubview:_imageView1];
    }
    return self;
}
- (void)setTwoModel:(TagsModel *)dataModel {
    TagsModel *skimmodel = dataModel;
//    NSLog(@"%@",skimmodel.icon);
    if (skimmodel.icon.length > 0 ) {
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:skimmodel.icon] placeholderImage:nil];
    }else{
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:skimmodel.image] placeholderImage:nil];
    }
    _label.text = skimmodel.name;
    _label.alpha = 0.5;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor blackColor];
    _label.textColor = [UIColor whiteColor];
}
@end
