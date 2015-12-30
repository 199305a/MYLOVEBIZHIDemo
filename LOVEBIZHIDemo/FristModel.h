//
//  FristModel.h
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SkimModel : JSONModel
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString<Optional> *icon;
@property (nonatomic, copy) NSString *url;
@end
@interface LoveModel : JSONModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create;
@property (nonatomic, copy) NSString *remove;
@end
@protocol TagsModel
@end
@interface TagsModel : JSONModel
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *icon;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic,copy)  NSString<Optional> *decs;
@end
@interface UserModel : JSONModel
@property (nonatomic, copy) NSString *addtag;
@property (nonatomic, strong) LoveModel *love;
@end
@interface ShareModel : JSONModel
@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pic;
@end
@interface CountsModel : JSONModel
@property (nonatomic, copy) NSString *loved;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *puzzle;
@end
@interface ImageModel : JSONModel
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString<Optional> *big;
@property (nonatomic, copy) NSString<Optional> *original;
@property (nonatomic, copy) NSString<Optional> *vip_original;
@property (nonatomic, copy) NSString<Optional> *diy;
@end
@protocol DataModel
@end

@protocol TagsModel1
@end
//@interface TagsModel1 : NSObject
////@property (nonatomic, copy) NSString *name;
////@property (nonatomic, copy) NSString *url;
//
//@end
@interface DataModel : JSONModel
@property (nonatomic, copy) NSString *enterable;
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *size_id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString<Optional> *categoryCname;
@property (nonatomic, copy) NSString *dlview;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) ImageModel *image;
@property (nonatomic, strong) CountsModel *counts;
@property (nonatomic, strong) ShareModel *share;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSMutableArray<TagsModel> *tags;

@property (nonatomic, strong) NSMutableArray<Optional> *tas1;
@property (nonatomic, copy) NSString<Optional> *imagesmall;
@property (nonatomic, copy) NSString <Optional>*imagebig;
@property (nonatomic, copy) NSString <Optional>*countsloved;
@property (nonatomic, copy) NSString <Optional>*countsdown;
@end
@interface LinkModel : JSONModel
@property (nonatomic, copy) NSString *prev;
@property (nonatomic, copy) NSString<Optional> *Jself;
@property (nonatomic, copy) NSString *next;
@end
@protocol SliderModel
@end
@interface SliderModel : JSONModel
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *analyze;
@property (nonatomic, copy) NSString *image;
@end
@interface URLModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *hot;
@property (nonatomic, copy) NSString<Optional> *newest;
@end
@interface FristModel : JSONModel
@property (nonatomic, strong) NSMutableArray<SliderModel,Optional> *slider;
@property (nonatomic, strong)  LinkModel<Optional>*link;
@property (nonatomic, strong)  URLModel<Optional>*url;
@property (nonatomic, strong) NSMutableArray<DataModel,Optional> *data;
@property (nonatomic, copy) NSMutableArray<TagsModel,Optional> *tags;
@property (nonatomic, copy) NSString<Optional> *word;
@property (nonatomic, copy) NSString<Optional> *kw;
@property (nonatomic, copy) NSString<Optional> *qs;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, copy) NSString<Optional> *desc;
@end
