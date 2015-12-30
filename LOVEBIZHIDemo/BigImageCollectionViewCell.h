//
//  BigImageCollectionViewCell.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/18.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FristModel.h"

@protocol ButtonsDelegate
- (void)popToDetailView:(NSString *)string;
@end

@interface BigImageCollectionViewCell : UICollectionViewCell
- (void)setModelWithData:(DataModel *)dataModel;
@property (nonatomic, weak) id<ButtonsDelegate>delegate;
@end
