//
//  ReadModel.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"carousel"];
    for (NSDictionary *dic in arr) {
        ReadModel *model = [[ReadModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}

@end
