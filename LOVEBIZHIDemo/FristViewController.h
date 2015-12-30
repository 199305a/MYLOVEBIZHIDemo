//
//  FristViewController.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "BaseViewController.h"

@class FristViewController;
@protocol FristViewControllerDelagate
- (void)createButtonAction:(FristViewController *)bvc;
@end
@interface FristViewController : BaseViewController
@property (nonatomic, weak) id<FristViewControllerDelagate>delegate ;

@end
