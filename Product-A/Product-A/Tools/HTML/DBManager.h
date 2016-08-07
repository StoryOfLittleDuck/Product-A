//
//  DBManager.h
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface DBManager : NSObject
@property (nonatomic, strong)FMDatabase *dataBase;

+(DBManager *)shareManager;


//关闭数据
-(void)close;
@end
