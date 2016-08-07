//
//  MyPlayerManager.h
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>//系统文件
#import "MusicPlayerViewController.h"
#import "DeleteModel.h"
//播放模式
typedef NS_ENUM(NSInteger,PlayType){
    ListPlay,
    SinglePlay,
    RandomPlay
};

//播放状态
typedef NS_ENUM(NSInteger,PlayState){
    Play,
    Pause
};
typedef void(^block)(MusicModel *);
typedef void(^block1)(MusicModel *);
typedef void(^Block)(BOOL);

typedef void(^changMusic)(BOOL);

@interface MyPlayerManager : NSObject
@property (nonatomic, copy)block block;
@property (nonatomic, copy)Block isblock;
@property (nonatomic, copy)block1 block1;
@property (nonatomic, assign)PlayType playType;
@property (nonatomic, assign)PlayState playState;
@property (nonatomic, strong)AVPlayer *avPlayer;
@property (nonatomic, strong)NSMutableArray *musicLists;
@property (nonatomic, strong)NSMutableArray *Dmusic;
@property (nonatomic, strong)NSString *musicName;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSInteger Dindex;
@property (nonatomic, assign)NSInteger first;
@property (nonatomic, assign)float currentTime;
@property (nonatomic, assign)float totalTime;
@property (nonatomic, strong)MusicModel *model;
//记录当前是播放还是暂停
@property (nonatomic, assign)BOOL isPlay;
@property (nonatomic, assign)BOOL isZT;

@property (nonatomic, copy) changMusic chang;

+(MyPlayerManager *)defaultManader;

//改变当前播放源的时间
-(void)seekToSecondsWith:(float)seconds;

#pragma mark --- 播放/暂停 ---
-(void)playAndPause;

#pragma mark ----- 时间获取 -----
//value = timeScale * Seconds
-(float)currentTime;

-(float)totalTime;

//上一首
-(void)lastMusic:(PlayType)type;

//下一首
-(void)nextMusic:(PlayType)type;

//根据index来切歌
-(void)replaceItemWithUrlString:(NSString *)urlString;
-(void)changeMusicWith:(NSInteger)index;
-(void)playMusicWith:(NSInteger)index;

//-(void)playDidFinish;

//播放
-(void)play;

//暂停
-(void)pause;

@end
