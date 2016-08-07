//
//  CModel.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CModel.h"

@implementation CModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSMutableArray *)CModelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"hotlist"];
    for (NSDictionary *dic in arr) {
        CModel *model = [[CModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}

@end
