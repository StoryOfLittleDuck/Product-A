//
//  ReadListModel.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadListModel.h"

@implementation ReadListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"list"];
    for (NSDictionary *dic in arr) {
        ReadListModel *model = [[ReadListModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
