//
//  PModel.m
//  Product-A
//
//  Created by 林建 on 16/7/3.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "PModel.h"

@implementation PModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"list"];
    for (NSDictionary *dic in arr) {
        PModel *model = [[PModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
