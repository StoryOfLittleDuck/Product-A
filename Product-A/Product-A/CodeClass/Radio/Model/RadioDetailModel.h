//
//  RadioDetailModel.h
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioDetailModel : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *musicvisitnum;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *uname;

+(NSMutableDictionary *)ModelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
