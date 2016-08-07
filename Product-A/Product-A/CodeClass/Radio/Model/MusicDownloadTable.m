//
//  MusicDownloadTable.m
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicDownloadTable.h"

@implementation MusicDownloadTable

-(instancetype)init{
    self = [super init];
    if (self) {
        _dateBase = [DBManager shareManager].dataBase;
    }
    return self;
}

//建表
-(void)creatTable{
//判断表是否存在
    NSString *query = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",kDownloadTable];
    FMResultSet *set = [_dateBase executeQuery:query];
    [set next];
    int count = [set intForColumnIndex:0];
    BOOL exist = count;
    if (exist) {
        NSLog(@"%@表存在",kDownloadTable);
    } else {
    //建表
        NSString *update = [NSString stringWithFormat:@"create table %@(musicID  INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,title text,name text,image blob,webUrl text,musicUrl text,musicImg text,musicPath text)",kDownloadTable];
        BOOL result = [_dateBase executeUpdate:update];
        if (result) {
            NSLog(@"%@创建成功",kDownloadTable);
        } else {
            NSLog(@"%@创建失败",kDownloadTable);
        }
    }
}

//插入
//INSERT INTO 表名 (参数 ) values(？)
-(void)insetIntoTable:(NSArray *)Info{
    NSString *update = [NSString stringWithFormat:@"INSERT INTO %@ (title ,name ,image ,webUrl ,musicUrl ,musicImg ,musicPath) values(?,?,?,?,?,?,?)",kDownloadTable];
    BOOL result = [_dateBase executeUpdate:update withArgumentsInArray:Info];
    if (result) {
        NSLog(@"成功插入");
    } else {
        NSLog(@"失败插入");
    }
}

-(void)deleteDatefortitle:(NSString *)title{
    NSString *string = [NSString stringWithFormat:@"delete from %@ where title = ?",kDownloadTable];
    NSString *titleString = [NSString stringWithFormat:@"%@",title];
    BOOL *flag = [_dateBase executeUpdate:string ,titleString];
}

//取出
-(NSArray *)selectAll{
    NSString *query = [NSString stringWithFormat:@"select *from %@",kDownloadTable];
    FMResultSet *set = [_dateBase executeQuery:query];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:[set columnCount]];
    while ([set next]) {
       NSString *title = [set stringForColumn:@"title"];
       NSString *name = [set stringForColumn:@"name"];
        NSData *image = [set dataForColumn:@"image"];
       NSString *webUrl = [set stringForColumn:@"webUrl"];
       NSString *musicUrl = [set stringForColumn:@"musicUrl"];
       NSString *musicImg = [set stringForColumn:@"musicImg"];
       NSString *musicPath = [set stringForColumn:@"musicPath"];
        [mArr addObject:@[title,name,image,webUrl,musicUrl,musicImg,musicPath]];
    }
    return mArr;
}

@end
