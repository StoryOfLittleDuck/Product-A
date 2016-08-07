//
//  ReadListModel.h
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadListModel : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *enname;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *type;

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
