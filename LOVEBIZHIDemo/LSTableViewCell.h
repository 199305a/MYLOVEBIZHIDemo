//
//  LSTableViewCell.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/20.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSModel.h"
@interface LSTableViewCell : UITableViewCell
- (void)setModelWithLsmodel:(ListModel*)model Andindex:(NSInteger)index;
@end
