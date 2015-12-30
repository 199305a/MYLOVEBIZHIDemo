//
//  LSModel.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/20.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ListModel
@end
@interface ListModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *WorksText;
@property (nonatomic, copy) NSString<Optional> *Singer;
@property (nonatomic, copy) NSString<Optional> *WorksName;
@property (nonatomic, copy) NSString<Optional> *Duration;
@property (nonatomic, copy) NSString<Optional> *WorksFileDownUrl;
@end
@interface JSModel : JSONModel
@property (nonatomic, strong) NSMutableArray<ListModel> *list;
@end
@interface LSModel : JSONModel
@property (nonatomic, strong) JSModel<Optional> *model;
@end
