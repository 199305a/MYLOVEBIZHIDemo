//
//  SecondModel.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/19.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LinksModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *prev;
@property (nonatomic, copy) NSString<Optional> *Jself;
@property (nonatomic, copy) NSString<Optional> *next;
@end

@protocol DatasModel

@end
@interface  DatasModel: JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString<Optional> *detail;
@end

@interface SecondModel : JSONModel
@property (nonatomic, strong)  LinksModel<Optional>*link;
@property (nonatomic, strong) NSMutableArray<DatasModel,Optional> *data;
@end
