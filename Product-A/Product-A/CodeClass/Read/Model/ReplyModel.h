//
//  ReplyModel.h
//  Product-A
//
//  Created by 林建 on 16/7/4.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
@property (nonatomic, strong)NSString *addtime_f;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *uname;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, assign)BOOL isL;
@property (nonatomic, strong)NSString *contentid;

+(NSMutableArray *)ModelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
