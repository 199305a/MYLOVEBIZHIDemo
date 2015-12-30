//
//  LSTableViewCell.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/20.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "LSTableViewCell.h"
#import "UIView+Common.h"

#define  Random arc4random()%256/255.0
@interface LSTableViewCell (){
    UILabel *_label1;
     UILabel *_label2;
     UILabel *_label3;
     UILabel *_label4;
    UIButton *_button;
    UIView *_view;
    UIColor * _color;
    NSDictionary *_dic;
}

@end
@implementation LSTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _view = [[UIView alloc]init];
        _label1 = [[UILabel alloc]init];
        [_view addSubview:_label1];
        _label2 = [[UILabel alloc]init];
        [_view addSubview:_label2];
        _label3 = [[UILabel alloc]init];
        [_view addSubview:_label3];
        _label4 = [[UILabel alloc]init];
        [_view addSubview:_label4];
        _button = [[UIButton alloc]init];
        [_view addSubview:_button];
         [self.contentView addSubview:_view];
        _dic = [NSDictionary new];
        _color = [UIColor colorWithRed:Random green:Random blue:Random alpha:1.0];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _view.frame = CGRectMake(10, 0, width(self.contentView)-20, height(self.contentView)-12);
    _label1.frame = CGRectMake(0, 0,width(_view)/10,height(_view));
    _label2.frame = CGRectMake(maxX(_label1)-1, 0,width(_view)*7/10, height(_view)*2/3);
    _label3.frame = CGRectMake(maxX(_label1)-1,height(_view)*2/3-1, width(_view)*7/10+1, height(_view)/3+1);
    _button.frame = CGRectMake(maxX(_label2)-1, 0, width(_view)*2/10+1, height(_view)*2/3);
    _label4.frame = CGRectMake(minX(_button)-1, maxY(_button)-1, width(_button)+1, height(_view)/3+1);
    _label1.textAlignment = NSTextAlignmentCenter;
    _label4.textAlignment = NSTextAlignmentCenter;
    _view.layer.shadowColor = [UIColor grayColor].CGColor;
    _view.layer.shadowOffset =CGSizeMake(3, 3);
    _view.layer.shadowRadius = 4;
    _view.clipsToBounds = YES;
    _view.layer.cornerRadius = 15;
    _view.layer.shadowOpacity = 0.7;
    _view.userInteractionEnabled = YES;
    _label1.textColor = [UIColor orangeColor];
    NSLog(@"%@",_dic);
    _label1.backgroundColor = _color;
    _label2.backgroundColor = _color;
    _label3.backgroundColor = _color;
    _label4.backgroundColor = _color;
    _button.backgroundColor = _color;
    _label2.textColor = [UIColor whiteColor];
    _label3.textColor = [UIColor whiteColor];
    _label4.textColor = [UIColor whiteColor];
    _button.titleLabel.textColor = [UIColor whiteColor];
}
- (void)setModelWithLsmodel:(ListModel *)model Andindex:(NSInteger)index{
//    NSLog(@"1");
    NSDictionary *lsmodel = model;
//    _dic = model;
    _label1.text = [NSString stringWithFormat:@"%ld",index];
    if (index <= 3) {
        _label1.tintColor = [UIColor orangeColor];
    }else {
        _label1.tintColor = [UIColor lightGrayColor];
    }
    _label2.text = lsmodel[@"WorksName"];
    _label2.font = [UIFont systemFontOfSize:16];
    _label3.text = [NSString stringWithFormat:@"%@-%@",lsmodel[@"Singer"],lsmodel[@"WorksText"]];
    _label3.font = [UIFont systemFontOfSize:13];
    _label4.text = lsmodel[@"Duration"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
