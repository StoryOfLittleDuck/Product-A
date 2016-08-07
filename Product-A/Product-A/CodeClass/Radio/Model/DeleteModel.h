//
//  DeleteModel.h
//  Product-A
//
//  Created by 林建 on 16/7/6.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteModel : NSObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSData *image;
@property (nonatomic, strong)NSString *webUrl;
@property (nonatomic, strong)NSString *musicUrl;
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *savePath;
@property (nonatomic, assign)BOOL isS;

+(NSMutableArray *)modelConfigureWithArray:(NSArray *)array;
@end
