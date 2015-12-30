//
//  ZTTableViewCell.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/19.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "ZTTableViewCell.h"
#import "UIView+Common.h"
#import <UIImage+WebP.h>
#import <UIImageView+WebCache.h>
@interface   ZTTableViewCell (){
    UIImageView *_imageVeiw;
    UILabel *_biglabel;
    UILabel *_textLabel;
    UIView *_view;
}

@end
@implementation ZTTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _view = [[UIView alloc]init];
        _imageVeiw = [[UIImageView alloc]init];
        _biglabel = [[UILabel alloc]init];
        _textLabel = [[UILabel alloc]init];
        [_view addSubview:_imageVeiw];
        [_view addSubview:_biglabel];
        [_view addSubview:_textLabel];
        [self.contentView addSubview:_view];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = CGRectMake(0, 0, width(self.contentView), height(self.contentView)-12);
    _imageVeiw.frame = CGRectMake(0, 0,height(_view), height(_view));
    _biglabel.frame = CGRectMake(maxX(_imageVeiw),0, width(_view)-maxX(_imageVeiw)-10, 30);
    _biglabel.font = [UIFont systemFontOfSize:20];
    _textLabel.frame = CGRectMake(minX(_biglabel), maxY(_biglabel),width(_biglabel), height(_view)- height(_biglabel));
    _view.layer.shadowColor = [UIColor grayColor].CGColor;
    _view.layer.shadowOffset =CGSizeMake(3, 3);
    _view.layer.shadowRadius = 4;
    _view.layer.shadowOpacity = 0.7;
    _view.userInteractionEnabled = YES;
    _textLabel.numberOfLines = 2;
    _biglabel.backgroundColor = [UIColor whiteColor];
    _biglabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:16];
    _textLabel.tintColor = [UIColor lightGrayColor];
    _textLabel.backgroundColor = [UIColor whiteColor];

}
- (void)setModelWithString:(DatasModel *)datastring {
    DatasModel *model = datastring;
    [_imageVeiw sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    _biglabel.text = model.name;

    _textLabel.text = model.desc;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
