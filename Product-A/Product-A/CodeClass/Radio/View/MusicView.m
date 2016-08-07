//
//  MusicView.m
//  Product-A
//
//  Created by 林建 on 16/6/29.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicView.h"
#import "MyPlayerManager.h"
@implementation MusicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

-(void)label1{
        _label = [[UILabel alloc]initWithFrame:CGRectMake(20, 490, 0, 0)];
        _label.text = @"已经下载过了...";
        _label.font = [UIFont fontWithName:@"Helvetica" size:13];
        _label.layer.borderColor = [[UIColor blackColor]CGColor];
        _label.layer.borderWidth = 0.5f;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = 10;
        _label.layer.masksToBounds = YES;
        _label.backgroundColor = [UIColor clearColor];
}

- (IBAction)Download:(id)sender {
    MyPlayerManager *manager = [MyPlayerManager defaultManader];
    MusicModel *model = manager.musicLists[manager.index];
    NSDictionary *dic = model.playInfo;
    NSDictionary *Dic = dic[@"authorinfo"];
    NSString *a = Dic[@"uname"];
    NSString *b = dic[@"webview_url"];
    UIImageView *imageV = [[UIImageView alloc]init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] completed:nil];
    NSData *c = [NSData dataWithBytes:(__bridge const void * _Nullable)(imageV.image) length:0];
    MusicDownloadTable *table = [[MusicDownloadTable alloc]init];
    NSArray *arr = [table selectAll];
      [table creatTable];
    //如果还未下载就执行这个
    if (arr.count == 0) {
        DownloadManager *dManager = [DownloadManager defaultManager];
        Download *task = [dManager createDownload:model.musicUrl];
        [task start];
        [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
            NSLog(@"%lld,%ld",bytesWritten,progress);
        } DidDownload:^(NSString *savePath, NSString *url) {
            NSLog(@"%@",savePath);
            //保存数据
            [table creatTable];
            [table insetIntoTable:@[model.title,a,b,c,model.musicUrl,model.coverimg,savePath]];
            
        }];
    }
    //遍历数据库 判断是否在下载过
    for (NSArray *arr1 in arr) {
        if ([arr1[0] isEqualToString: model.title]) {
            _aaa = 1;
        }
    }
    if (_aaa == 1) {
        _aaa = 0;
        [self label1];
        [self addSubview:self.label];
        [UIView animateWithDuration:2 animations:^{
            _label.frame = CGRectMake(20,490,130,30);
        } completion:^(BOOL finished) {
            _label.frame = CGRectMake(20, 490, 0, 0);
        }];
            } else {
        DownloadManager *dManager = [DownloadManager defaultManager];
        Download *task = [dManager createDownload:model.musicUrl];
        [task start];
        [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
            NSLog(@"%lld,%ld",bytesWritten,progress);
        } DidDownload:^(NSString *savePath, NSString *url) {
            NSLog(@"%@",savePath);
            //保存数据
            [table creatTable];
            [table insetIntoTable:@[model.title,a,b,c,model.musicUrl,model.coverimg,savePath]];
        }];
    }
}


- (IBAction)changeProgress:(UISlider *)sender {
    UISlider *slider = sender;
    [[MyPlayerManager defaultManader] seekToSecondsWith:slider.value];

}
 
@end
