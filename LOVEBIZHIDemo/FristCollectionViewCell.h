//
//  FristCollectionViewCell.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/16.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FristModel.h"

@protocol ButtonDelegate
- (void)popToDetailView:(NSString *)string;
@end
//@protocol ImageDelegate
//- (void)popToDetailView1:(NSString *)string;
//@end
@protocol downLoadButtonDelegate
- (void)popToDetailViewwithError:(NSError *)string;
@end


@interface FristCollectionViewCell : UICollectionViewCell
- (void)setModel:(DataModel *)dataModel With:(NSInteger)row;
@property (nonatomic, weak) id<ButtonDelegate>delegate;
@property (nonatomic, weak) id<downLoadButtonDelegate>downLoaddelegate;
@end
