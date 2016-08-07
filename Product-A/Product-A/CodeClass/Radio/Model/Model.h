//
//  Model.h
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *radioid;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *uname;
@property (nonatomic, assign)BOOL isDownload;

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
