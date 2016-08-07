//
//  MusicDownloadTable.h
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicDownloadTable : NSObject
@property (nonatomic, strong)FMDatabase *dateBase;
//建表
-(void)creatTable;

//插入
-(void)insetIntoTable:(NSArray *)Info;

//取出
-(NSArray *)selectAll;

-(void)deleteDatefortitle:(NSString *)title;
@end
