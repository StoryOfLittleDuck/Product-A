//
//  DModel.h
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DModel : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSDictionary *userinfo;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *radioid;
+(NSMutableArray *)DModelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
