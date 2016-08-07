//
//  CommunityModel.h
//  Product-A
//
//  Created by 林建 on 16/7/5.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject
@property (nonatomic, strong)NSString *addtime_f;
@property (nonatomic, strong)NSString *like;
@property (nonatomic, strong)NSString *comment;
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *contentid;

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end