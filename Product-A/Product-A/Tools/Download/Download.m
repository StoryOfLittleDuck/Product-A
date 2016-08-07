//
//  Download.m
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "Download.h"
@interface Download ()<NSURLSessionDownloadDelegate>
@property (nonatomic, strong)NSURLSessionDownloadTask *task;
@property (nonatomic, copy)DidDownload didDownload;
@property (nonatomic, copy)Downloading downloading;
@end
@implementation Download
-(void)dealloc{
    _delegate =nil;
    NSLog(@"%s",__FUNCTION__);
}

-(instancetype)initWith:(NSString *)url{
    self = [super init];
    if (self) {
        //设置下载配置
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        //根据配置创建网络会话
        NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
        _url = url;
    }
    return self;
}

-(void)start{
    [_task resume];
}

#pragma mark ----- 下载代理 -----
//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location{
//    caches
    NSString *cashesPath = [NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject];
    //拼接下载路径
    NSString *filePath = [cashesPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSFileManager *fm = [NSFileManager defaultManager];
    //location.path;
    NSLog(@"loaction ==== %@",location.path);
    [fm moveItemAtPath:location.path toPath:filePath error:nil];
//    location.path;
    if (_didDownload) {
        _didDownload(filePath,_url);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(removeDownloadTask:)]) {
        [_delegate removeDownloadTask:_url];
    }
    [session invalidateAndCancel];//关闭会话
}

//下载中
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    float progress = (float)totalBytesWritten /totalBytesExpectedToWrite;
    _progress = progress *100;
    if (_downloading) {
        //速度，进度
        _downloading(bytesWritten , _progress);
    }
}

//监听下载
-(void)monitorDownload:(Downloading)downloading DidDownload:(DidDownload)didDownload{
    _downloading = downloading;
    _didDownload = didDownload;
//Dowaload参数
}
@end
