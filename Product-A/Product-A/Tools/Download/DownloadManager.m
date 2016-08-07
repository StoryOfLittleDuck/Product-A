//
//  DownloadManager.m
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "DownloadManager.h"

static DownloadManager *manager = nil;
@interface DownloadManager()<DownloadDelegate>
@property (nonatomic, strong)NSMutableDictionary *dic;//存放下载任务
@end
@implementation DownloadManager
+(DownloadManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc]init];
    });
    return manager;
}

-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc]init];
    }
    return _dic;
}

//创建一个下载任务
-(Download *)createDownload:(NSString *)url{
    Download *task = self.dic[url];
    if (!task) {
        task = [[Download alloc]initWith:url];
        [self.dic setValue:task forKey:url];
    }
    task.delegate = self;
    return task;
}

-(void)removeDownloadTask:(NSString *)url{
    [self.dic removeObjectForKey:url];
}
@end
