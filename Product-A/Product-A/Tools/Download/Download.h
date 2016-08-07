//
//  Download.h
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Downloading)(long long bytesWritten,NSInteger progress);//下载中，返回瞬时速度和进度
typedef void(^DidDownload)(NSString *savePath,NSString *url);//下载完成，返回保存路径和下载地址
@protocol DownloadDelegate <NSObject>
-(void)removeDownloadTask:(NSString *)url;
@end

@interface Download : NSObject
@property (nonatomic, strong)NSString *url;//下载地址
@property (nonatomic, assign)NSInteger progress;//下载速度
@property (nonatomic, assign)id<DownloadDelegate>delegate;
//给一个下载地址 初始化
-(instancetype)initWith:(NSString *)url;

//开始下载
-(void)start;

//监听下载的方法
-(void)monitorDownload:(Downloading)downloading DidDownload:(DidDownload)didDownload;

@end
