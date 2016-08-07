//
//  MusicModel.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *Dic = jsonDic[@"data"];
    NSArray *arr = Dic[@"list"];
    for (NSDictionary *dic in arr) {
        MusicModel *model = [[MusicModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [Arr addObject:model];
    }
    return Arr;
}
@end
