//
//  ReadDetailModel.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadDetailModel.h"

@implementation ReadDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)ModelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"list"];
    for (NSDictionary  *dic in arr) {
        ReadDetailModel *model = [[ReadDetailModel alloc]init];
        model.ider = dic[@"id"];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
