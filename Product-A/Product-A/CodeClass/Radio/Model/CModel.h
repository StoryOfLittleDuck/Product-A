//
//  CModel.h
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CModel : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *radioid;

+(NSMutableArray *)CModelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
