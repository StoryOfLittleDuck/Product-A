//
//  CommunityModel.m
//  Product-A
//
//  Created by 林建 on 16/7/5.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CommunityModel.h"

@implementation CommunityModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *data = jsonDic[@"data"];
    NSArray *arr = data[@"list"];
    for (NSDictionary *dic in arr) {
        CommunityModel *model = [[CommunityModel alloc]init];
        NSDictionary *list = dic[@"counterList"];
        model.comment = list[@"comment"];
        model.like = list[@"like"];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
