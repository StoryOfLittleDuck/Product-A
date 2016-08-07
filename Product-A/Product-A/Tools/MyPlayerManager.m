//
//  MyPlayerManager.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MyPlayerManager.h"

@implementation MyPlayerManager
+(MyPlayerManager *)defaultManader{
    static MyPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyPlayerManager alloc]init];
    });
    return manager;
}



-(instancetype)init{
    self = [super init];
    if (self) {
        _playType = ListPlay;
        _playState = Pause;
    }
    return self;
}

//设置数据
-(void)setMusicLists:(NSMutableArray *)musicLists{
    [_musicLists removeAllObjects];
    _musicLists = [musicLists mutableCopy];
    MusicModel *model =_musicLists[_index];
    AVPlayerItem *avplayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.musicUrl]];
    if (!_avPlayer) {
        //没有 初始化
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:avplayerItem];
    } else {
        //有
        [_avPlayer replaceCurrentItemWithPlayerItem:avplayerItem];
    }
}

-(void)setDmusic:(NSMutableArray *)Dmusic{
    [_Dmusic removeAllObjects];
    _Dmusic = [Dmusic mutableCopy];
    NSString *filePath = [self creatSqliteWithSqliteName:kDownloadTable];
    NSMutableArray *arr = self.Dmusic[_Dindex];
    NSString *path = arr[6];
    NSString *music = [[path componentsSeparatedByString:@"/"]lastObject];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"Documents/神盾局" withString:[NSString stringWithFormat:@"Library/Caches/%@",music]];
    NSURL *audioUrl = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *avplayerItem = [AVPlayerItem playerItemWithURL:audioUrl];
    if (!_avPlayer) {
        //没有 初始化
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:avplayerItem];
    } else {
        //有
        [_avPlayer replaceCurrentItemWithPlayerItem:avplayerItem];
    }

}

#pragma mark --- 播放/暂停 ---
-(void)playAndPause{
    //如果是播放让其暂停
    if (self.isPlay == YES) {
        [self pause];
        self.isPlay = NO;
    } else {
        [self play];
        self.isPlay = YES;
    }
    //block传递播放状态
    if (self.isblock != nil) {
        self.isblock(self.isPlay);
    }
    if (self.chang != nil) {
        self.chang(self.isPlay);
    }
}

//播放
-(void)play{
    [_avPlayer play];
    _playState = Play;
}

//暂停
-(void)pause{
    [_avPlayer pause];
    _playState = Pause;
}

//停止
-(void)stop{
    [self seekToSecondsWith:0];
    _playState = Pause;
}

//改变当前播放源的时间
-(void)seekToSecondsWith:(float)seconds{
    CMTime newTime = _avPlayer.currentTime;
    newTime.value = newTime.timescale * seconds;
    [_avPlayer seekToTime:newTime];
    [self play];
}

#pragma mark ----- 时间获取 -----
//value = timeScale * Seconds
-(float)currentTime{
    if (_avPlayer.currentTime.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
}

-(float)totalTime{
//    _avPlayer.currentItem.timebase
    if (_avPlayer.currentItem.duration.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentItem.duration.value/_avPlayer.currentItem.duration.timescale;
}

//上一首
-(void)lastMusic:(PlayType)type{
    if (type == RandomPlay) {
        _index = arc4random()%_musicLists.count;
    } if(type == ListPlay) {
        if (_index == 0) {
            _index = _musicLists.count - 1;
        } else{
            _index --;
        }
            }
    if (type == SinglePlay) {
        
        
    }
//    [self changeMusicWith:_index];
}

//下一首
-(void)nextMusic:(PlayType)type{
    if (type == RandomPlay) {
        _index = arc4random()%_musicLists.count;
    } if(type == ListPlay)
    {
        if (_index == _musicLists.count -1) {
            _index = 0;
        } else {
        _index ++;
        }
    }
    if (type == SinglePlay) {
       
        
    }
//    [self changeMusicWith:_index];
}

//根据index来切歌

-(void)replaceItemWithUrlString:(NSString *)urlString{
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    [self play];
}

-(void)changeMusicWith:(NSInteger)index{
    _index = index;
    MusicModel *model =_musicLists[index];
    self.musicName = model.title;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:model.musicUrl]];
    [_avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    if (self.block != nil) {
        self.block(model);
    }
    if (self.block1 != nil) {
        self.block1(model);
    }
    [self play];
}

-(void)playMusicWith:(NSInteger)index{
    _Dindex = index;
    NSString *filePath = [self creatSqliteWithSqliteName:kDownloadTable];
    NSMutableArray *arr = self.Dmusic[index];
    NSString *path = arr[6];
    NSString *music = [[path componentsSeparatedByString:@"/"]lastObject];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"Documents/神盾局" withString:[NSString stringWithFormat:@"Library/Caches/%@",music]];
    NSURL *audioUrl = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
    [_avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self play];
}

-(NSString *)creatSqliteWithSqliteName:(NSString *)sqliteName{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:sqliteName];
}

@end
