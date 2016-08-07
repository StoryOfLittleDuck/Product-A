//
//  RadioDetailModel.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RadioDetailModel.h"

@implementation RadioDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+(NSMutableDictionary *)ModelConfigureWithJsonDic:(NSDictionary *)jsonDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *Dic = jsonDic[@"data"];
    dic = Dic[@"radioInfo"];
    
    return dic;
}
@end
