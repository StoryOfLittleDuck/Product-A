//
//  Model.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "Model.h"

@implementation Model

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"alllist"];
    for (NSDictionary *dic in arr) {
        Model *model =[[Model alloc]init];
        model.isDownload = NO;
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
