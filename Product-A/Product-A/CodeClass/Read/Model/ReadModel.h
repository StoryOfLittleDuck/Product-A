//
//  ReadModel.h
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadModel : NSObject
@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *url;
+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
