//
//  MusicModel.h
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, strong)NSString *musicUrl;
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *sharetext;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *musicVisit;
@property (nonatomic, strong)NSDictionary *playInfo;
@property (nonatomic, assign)BOOL isSelect;
@property (nonatomic, assign)BOOL isDownload;

+(NSMutableArray *)modelConfigureWithJsonDic:(NSDictionary *)jsonDic;
@end
