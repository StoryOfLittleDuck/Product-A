//
//  ReplyModel.m
//  Product-A
//
//  Created by 林建 on 16/7/4.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReplyModel.h"
#import "UserInfoManager.h"

@implementation ReplyModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableArray *)ModelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *Arr = [NSMutableArray array];
    NSDictionary *data = jsonDic[@"data"];
    NSArray *arr = data[@"list"];
    for (NSDictionary *dic in arr) {
        ReplyModel *model = [[ReplyModel alloc]init];
        NSDictionary *use = dic[@"userinfo"];
//        NSLog(@"%@",use);
        model.icon = use[@"icon"];
        model.uname = use[@"uname"];
        [model setValuesForKeysWithDictionary:dic];
//        NSLog(@"%@", [UserInfoManager getUserName]);
        
        if ([model.uname isEqualToString: [UserInfoManager getUserName]]) {
            model.isL = YES;
        }
        [Arr addObject:model];
    }
    return Arr;
}
@end
