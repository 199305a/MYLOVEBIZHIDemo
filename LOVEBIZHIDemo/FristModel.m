//
//  FristModel.m
//  LOVEBIZHIDemo
//
//  Created by QianFeng on 15/12/15.
//  Copyright © 2015年 CUIHAO. All rights reserved.
//

#import "FristModel.h"

@implementation SkimModel


@end
@implementation LoveModel

@end
@implementation TagsModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"decs":@"description"}];
}
@end
@implementation UserModel

@end
@implementation ShareModel

@end
@implementation CountsModel

@end
@implementation ImageModel

@end
@implementation DataModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"image.small":@"imagesmall",@"image.big":@"imagebig",@"counts.loved":@"countsloved",@"counts.down":@"countsdown"}];
}
@end
@implementation LinkModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"Jself":@"self"}];
}
@end
@implementation SliderModel

@end
@implementation FristModel
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([@"description" isEqualToString:key]) {
//        self.desc = value;
//    }
//}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"desc"}];
}
@end