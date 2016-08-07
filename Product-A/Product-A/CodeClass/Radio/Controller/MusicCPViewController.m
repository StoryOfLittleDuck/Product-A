//
//  MusicCPViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/2.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicCPViewController.h"
#import "DeleteModel.h"
#import "MusicView.h"
@interface MusicCPViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *aboveB;
@property (nonatomic, strong)UIButton *nextB;
@property (nonatomic, strong)UIButton *playB;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UIView *s1V;
@property (nonatomic, strong)UIView *s2V;
@property (nonatomic, strong)UIView *s3V;
@property (nonatomic, strong)UIView *playView;
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)MusicView *PlayerV;
@property (nonatomic, assign)PlayType pType;
@property (nonatomic, strong)NSMutableArray *modelArr;
@property (nonatomic, strong)UIBlurEffect *beffect;
@property (nonatomic, strong)UIVisualEffectView *effectV;
@end

@implementation MusicCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    UIView *vertical1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 20, 1, KNaviH)];
    vertical1.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical1];
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH-1, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    
    [self.view addSubview:horizontal];
    [self.view addSubview:self.button];
    [self.view addSubview:self.s1V];
    [self.view addSubview:self.s2V];
    [self.view addSubview:self.s3V];
    [self.view addSubview:self.scrollV];
    [self.scrollV addSubview:self.PlayerV];
    [self.view addSubview:self.playView];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建滑块视图 -----
-(UIView *)s1V{
    if (!_s1V) {
        _s1V = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20 -20-40, kScreenHeight - 69, 40, 3)];
        _s1V.backgroundColor = [UIColor grayColor];
    }
    return _s1V;
}

-(UIView *)s2V{
    if (!_s2V) {
        _s2V = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20, kScreenHeight - 69, 40, 3)];
        _s2V.backgroundColor = [UIColor greenColor];
    }
    return _s2V;
}

-(UIView *)s3V{
    if (!_s3V) {
        _s3V = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20 +40 +20, kScreenHeight - 69, 40, 3)];
        _s3V.backgroundColor = [UIColor grayColor];
    }
    return _s3V;
}


#pragma mark ----- 创建主视图(scrollView) -----
-(UIScrollView *)scrollV{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60,kScreenWidth, kScreenHeight-64-60 -10)];
        _scrollV.backgroundColor = [UIColor grayColor];
        _scrollV.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight - 60- 64 -10);
        self.scrollV.contentOffset = CGPointMake(kScreenWidth, 0);
        _scrollV.delegate = self;
        _scrollV.pagingEnabled = YES;
        _scrollV.showsHorizontalScrollIndicator = NO;
    }
    return _scrollV;
}

#pragma mark ----- scrollView协议方法 -----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        _s1V.backgroundColor = [UIColor greenColor];
        _s2V.backgroundColor = [UIColor grayColor];
        _s3V.backgroundColor = [UIColor grayColor];
    }else if (scrollView.contentOffset.x == scrollView.width){
        _s1V.backgroundColor = [UIColor grayColor];
        _s2V.backgroundColor = [UIColor greenColor];
        _s3V.backgroundColor = [UIColor grayColor];
    } else if (scrollView.contentOffset.x == scrollView.width *2){
        _s1V.backgroundColor = [UIColor grayColor];
        _s2V.backgroundColor = [UIColor grayColor];
        _s3V.backgroundColor = [UIColor greenColor];
    }
}

#pragma mark ----- 播放界面按钮(底部) -----
-(UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64)];
        
        //播放 暂停
        _playB = [UIButton buttonWithType:UIButtonTypeCustom];
        _playB.frame = CGRectMake((kScreenWidth/2)-20 , 10, 40, 40);
        if ([MyPlayerManager defaultManader].isPlay == YES) {
            [_playB setImage:[UIImage imageNamed:@"music_icon_stop_highlighted@2x.png"] forState:UIControlStateNormal];
        } else {
            [_playB setImage:[UIImage imageNamed:@"music_icon_play_highlighted@2x.png"] forState:UIControlStateNormal];
        }
        [_playB addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_playB];
        //上一首
        _aboveB = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboveB.frame = CGRectMake(60 ,10, 40, 40);
        [_aboveB setImage:[UIImage imageNamed:@"music_icon_last_highlighted@2x.png"] forState:UIControlStateNormal];
        [_aboveB addTarget:self action:@selector(aboveA:) forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_aboveB];
        //下一首
        _nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextB.frame = CGRectMake(kScreenWidth - 100 ,10, 40, 40);
        [_nextB setImage:[UIImage imageNamed:@"music_icon_next_highlighted@2x.png"] forState:UIControlStateNormal];
        [_nextB addTarget:self action:@selector(nextA:) forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_nextB];
        //
        UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(40,1, kScreenWidth-80, 1)];
        horizontal.backgroundColor = [UIColor grayColor];
        [_playView addSubview:horizontal];
    }
    return _playView;
}

#pragma mark ----- 创建播放视图 -----
-(MusicView *)PlayerV{
    if (!_PlayerV) {
        _PlayerV = [[[NSBundle mainBundle] loadNibNamed:@"MusicView" owner:self options:nil] firstObject];
        _PlayerV.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 -60 -10);
        _PlayerV.backgroundColor = [UIColor whiteColor];
        //修改音乐图像
        self.PlayerV.imageV.image = [UIImage imageNamed:@"Mbh9GkmUK_1323596742.jpg"];
        self.PlayerV.backgroundColor = [UIColor colorWithPatternImage:self.PlayerV.imageV.image];
        [self reloadViewWithIndex:[MyPlayerManager defaultManader].Dindex];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [self.timer fire];
                //动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.duration = 8;
        animation.repeatCount = FLT_MAX;
        [_PlayerV.imageV.layer addAnimation:animation forKey:nil];
    }
    return _PlayerV;
}

#pragma mark ----- 改变标题 音乐图像 歌曲音频 -----
-(void)reloadViewWithIndex:(NSInteger)index{
    //寻找对应model
    NSMutableArray *arr = self.Arr[index];
    self.PlayerV.descL.text = arr[0];
    
    //背景模糊
    [self.PlayerV insertSubview:self.effectV belowSubview:self.PlayerV.backV];
    self.PlayerV.imageV.layer.masksToBounds = YES;
    self.PlayerV.imageV.layer.cornerRadius = 140;

        //一上来进度条为零
        _PlayerV.playSilder.value = 0;
        [[MyPlayerManager defaultManader] playMusicWith:index];
        [MyPlayerManager defaultManader].isPlay = YES;
//
}

#pragma mark ----- 定时器方法 -----
-(void)timeAction{
    long long int allTime = [[MyPlayerManager defaultManader] totalTime];
    long long int currentTimer = [[MyPlayerManager defaultManader] currentTime];
    self.PlayerV.timeL.text = [NSString stringWithFormat:@"%02lld:%02lld",currentTimer / 60,currentTimer % 60];
    self.PlayerV.playSilder.maximumValue = allTime;
    self.PlayerV.playSilder.value = currentTimer;
    if (self.PlayerV.playSilder.value >= allTime -1 && allTime != 0) {
        [[MyPlayerManager defaultManader] nextMusic:self.pType];
        [self reloadViewWithIndex:[MyPlayerManager defaultManader].Dindex];
    }
}

#pragma mark ----- 模糊界面 -----
-(UIBlurEffect *)beffect{
    if (!_beffect) {
        _beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return _beffect;
}

-(UIVisualEffectView *)effectV{
    if (!_effectV) {
        _effectV = [[UIVisualEffectView alloc]initWithEffect:self.beffect];
        _effectV.frame = self.PlayerV.bounds;
    }
    return _effectV;
}

#pragma mark ----- 播放按钮 -----
-(void)playAndPause:(id)sender{
    UIButton *button = sender;
    [[MyPlayerManager defaultManader] playAndPause];
    //如果是播放 让其显示暂停按钮
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        [button setImage:[UIImage imageNamed:@"music_icon_stop_highlighted@2x.png"] forState:UIControlStateNormal];
        [self resumeLayer:self.PlayerV.imageV.layer];
    } else {
        [button setImage:[UIImage imageNamed:@"music_icon_play_highlighted@2x.png"] forState:UIControlStateNormal];
        [self pauseLayer:self.PlayerV.imageV.layer];
    }

}

#pragma mark ----- 上一首歌 -----
-(void)aboveA:(id)sender{

}

#pragma mark ----- 下一首歌 -----
-(void)nextA:(id)sender{

}


#pragma mark ----- 返回按钮 -----
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,20, KNaviH, KNaviH);
        [_button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyPlayerManager defaultManader].isPlay = ![MyPlayerManager defaultManader].isPlay;
    [self playAndPause:self.playB];
}

//暂停动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}


//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
