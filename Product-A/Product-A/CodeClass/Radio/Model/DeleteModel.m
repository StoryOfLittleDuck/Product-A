//
//  DeleteModel.m
//  Product-A
//
//  Created by 林建 on 16/7/6.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "DeleteModel.h"

@implementation DeleteModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)modelConfigureWithArray:(NSArray *)array{
    NSMutableArray *Arr = [NSMutableArray array];
    for (NSArray *arr in array) {
        DeleteModel *model = [[DeleteModel alloc]init];
        model.title = arr[0];
        model.name = arr[1];
        model.image = arr[2];
        model.webUrl = arr[3];
        model.musicUrl = arr[4];
        model.coverimg = arr[5];
        model.savePath = arr[6];
        model.isS = NO;
        [Arr addObject:model];
    }
    return Arr;
}

@end
