//
//  MusicPlayerViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "MusicListTableViewCell.h"
#import "MusicModel.h"
#import "MusicView.h"
@interface MusicPlayerViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *playB;
@property (nonatomic, strong)UIButton *aboveB;
@property (nonatomic, strong)UIButton *nextB;
@property (nonatomic, strong)UIButton *playWay;
@property (nonatomic, strong)UIView *playView;
@property (nonatomic, strong)UIView *SongWordV;
@property (nonatomic, strong)UIView *s1V;
@property (nonatomic, strong)UIView *s2V;
@property (nonatomic, strong)UIView *s3V;
@property (nonatomic, strong)UIWebView *wView;
@property (nonatomic, assign)PlayType pType;
@property (nonatomic, strong)MusicView *PlayerView;
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)UIBlurEffect *beffect;
@property (nonatomic, strong)UIVisualEffectView *effectV;
@property (nonatomic, strong)NSString *transitionType;
@property (nonatomic, strong)NSString *transitionSubtype;
@property (nonatomic, assign)NSInteger wayC;
@property (nonatomic, assign)NSInteger scrollIndex;
@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollIndex = 1;
    [MyPlayerManager defaultManader].index = self.index;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    [self.view addSubview:horizontal];
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.scrollV];
    [self.view addSubview:self.playWay];
    [self.view addSubview:self.s1V];
    [self.view addSubview:self.s2V];
    [self.view addSubview:self.s3V];
    [self.scrollV addSubview:self.PlayerView];
    [self.scrollV addSubview:self.tableV];
    [self.view addSubview:self.playView];
    [self SongWordV1];
    //向左清扫
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(left)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollV addGestureRecognizer:swipLeft];
    //向右清扫
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(right)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollV addGestureRecognizer:swipRight];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextB:) name:@"backNext" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aboveB:) name:@"backAbove" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextB:) name:@"backReload" object:nil];
    // Do any additional setup after loading the view from its nib.
}


-(void)left{
    self.scrollIndex++;
    CGPoint offset = self.scrollV.contentOffset;
    if (offset.x >= kScreenWidth *2) {
        self.scrollIndex = 0;
    }
    _transitionType = @"cube";
    _transitionSubtype = @"fromRight";
    [self transitionAction];
}

-(void)right{
    self.scrollIndex--;
    CGPoint offset = self.scrollV.contentOffset;
    if (offset.x <= 0) {
        self.scrollIndex = 2;
    }
    _transitionType = @"rippleEffect";
    _transitionSubtype = @"fromLeft";
    [self transitionAction];
}

#pragma mark ----- 过场动画 -----
-(void)transitionAction{
    [self.scrollV setContentOffset:CGPointMake(kScreenWidth * (self.scrollIndex) , 0) animated:YES];
    
    CATransition *transition = [[CATransition alloc]init];
    transition.type = _transitionType;//转场动画的类型
    transition.subtype = _transitionSubtype;//动画方向
    transition.duration = 0.5;//持续时间
    [self.scrollV.layer addAnimation:transition forKey:@"transition"];
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
        _scrollV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"58X58PICBev_1024.jpg"]];
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

#pragma mark ----- 创建歌单界面 -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64-60-10) style:(UITableViewStylePlain)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [_tableV registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"mListCell"];
    }
    return _tableV;
}


#pragma mark ----- tableView协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MyPlayerManager defaultManader].musicLists.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index1 != nil) {
        self.index1(indexPath.row);
    }
    //判断是否重复点击
    if ([MyPlayerManager defaultManader].index == indexPath.row) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollV.contentOffset = CGPointMake(kScreenWidth, 0);
        }];
    } else {
        [self reloadViewWithIndex:indexPath.row];
        [MyPlayerManager defaultManader].index = indexPath.row;
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollV.contentOffset = CGPointMake(kScreenWidth, 0);
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel *model = self.array[indexPath.row];
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mListCell"];
    [cell cellWithModel:model];
    MusicDownloadTable *table = [[MusicDownloadTable alloc]init];
    NSArray *arr = [table selectAll];
    if (arr.count == 0) {
        [cell.downloadB setImage:[UIImage imageNamed:@"下载.png"] forState:UIControlStateNormal];
        [cell.downloadB addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.downloadB.tag = indexPath.row ;
    }
    int count = 0;
    for (NSArray *arr1 in arr) {
        if ([arr1[0] isEqualToString: model.title]) {
            count ++;
        }
    }
    if (count == 0) {
        [cell.downloadB setImage:[UIImage imageNamed:@"下载.png"] forState:UIControlStateNormal];
        [cell.downloadB addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.downloadB.tag = indexPath.row ;
    }  else {
        [cell.downloadB setImage:[UIImage imageNamed:@"下载完成-dict.png"] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark ----- 下载按钮方法 -----
-(void)downloadAction:(UIButton*)button{
    MyPlayerManager *manager = [MyPlayerManager defaultManader];
    MusicModel *model = manager.musicLists[button.tag];
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
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%ld",progress] forState:UIControlStateNormal];
        } DidDownload:^(NSString *savePath, NSString *url) {
            NSLog(@"%@",savePath);
            //保存数据
            [table creatTable];
            [table insetIntoTable:@[model.title,a,b,c,model.musicUrl,model.coverimg,savePath]];
            [button setImage:[UIImage imageNamed:@"下载完成-dict.png"] forState:UIControlStateNormal];
        }];
    }  else{
    //遍历数据库 判断是否在下载过
    for (NSArray *arr1 in arr) {
        if ([arr1 containsObject: model.title]) {
            
        } else {
            DownloadManager *dManager = [DownloadManager defaultManager];
            Download *task = [dManager createDownload:model.musicUrl];
            [task start];
            [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
                NSLog(@"%lld,%ld",bytesWritten,progress);
                [button setImage:nil forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%ld%%",(long)progress] forState:UIControlStateNormal];
                button.titleLabel.textColor = [UIColor blackColor];
            } DidDownload:^(NSString *savePath, NSString *url) {
                NSLog(@"%@",savePath);
                //保存数据
                [table creatTable];
                [table insetIntoTable:@[model.title,a,b,c,model.musicUrl,model.coverimg,savePath]];
                [button setImage:[UIImage imageNamed:@"下载完成-dict.png"] forState:UIControlStateNormal];
            }];
        }
     }
    }
    [self.tableV reloadData];
}

#pragma mark ----- 创建歌词界面 -----
-(void)SongWordV1{
        self.SongWordV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 64 -60 -10)];
    [self creatWebV];
    [self requestData:self.index];
    [self.scrollV addSubview:self.SongWordV];
}

#pragma mark ----- 创建播放视图 -----
-(MusicView *)PlayerView{
    if (!_PlayerView) {
        _PlayerView = [[[NSBundle mainBundle] loadNibNamed:@"MusicView" owner:self options:nil] firstObject];
        _PlayerView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 -60 -10);
        _PlayerView.backgroundColor = [UIColor whiteColor];
       
        
        NSInteger index = [MyPlayerManager defaultManader].index;
        [self reloadViewWithIndex:index];
        self.model = self.array[index];
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [self.timer fire];
        //动画
       CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.duration = 8;
        animation.repeatCount = FLT_MAX;
        [_PlayerView.imageV.layer addAnimation:animation forKey:nil];
    }
    return _PlayerView;
}

#pragma mark ----- 改变标题 音乐图像 歌曲音频 -----
-(void)reloadViewWithIndex:(NSInteger)index{
    //寻找对应model
    self.model = self.array[index];
    self.PlayerView.descL.text = self.model.title;
    MusicListTableViewCell *cell = [self.tableV dequeueReusableCellWithIdentifier:@"mListCell"];
    [cell cellWithModel:self.model];
    //修改音乐图像
    [self.PlayerView.imageV sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg] completed:nil];
    self.PlayerView.backgroundColor = [UIColor colorWithPatternImage:self.PlayerView.imageV.image];
    //背景模糊
    [self.PlayerView insertSubview:self.effectV belowSubview:self.PlayerView.backV];
    self.PlayerView.imageV.layer.masksToBounds = YES;
    self.PlayerView.imageV.layer.cornerRadius = 140;
    if (self.model.isSelect == YES) {
        self.model.isSelect =NO;
        return;
    } else {
    //一上来进度条为零
     _PlayerView.playSilder.value = 0;
    [[MyPlayerManager defaultManader] changeMusicWith:index];
    [MyPlayerManager defaultManader].isPlay = YES;
        self.model.isSelect =YES;
    }
    [self.tableV reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backPlay" object:self.model];
}

-(UIBlurEffect *)beffect{
    if (!_beffect) {
        _beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return _beffect;
}

-(UIVisualEffectView *)effectV{
    if (!_effectV) {
        _effectV = [[UIVisualEffectView alloc]initWithEffect:self.beffect];
        _effectV.frame = self.PlayerView.bounds;
    }
    return _effectV;
}

#pragma mark ----- 定时器方法 -----
-(void)timeAction{
    long long int allTime = [[MyPlayerManager defaultManader] totalTime];
    long long int currentTimer = [[MyPlayerManager defaultManader] currentTime];
    self.PlayerView.timeL.text = [NSString stringWithFormat:@"%02lld:%02lld",currentTimer / 60,currentTimer % 60];
    self.PlayerView.playSilder.maximumValue = allTime;
    self.PlayerView.playSilder.value = currentTimer;
    if (self.PlayerView.playSilder.value >= allTime -1 && allTime != 0) {
        [[MyPlayerManager defaultManader] nextMusic:self.pType];
     [self reloadViewWithIndex:[MyPlayerManager defaultManader].index];
        [self requestData:[MyPlayerManager defaultManader].index];
    }
}

#pragma mark -----数据请求 -----
#warning message  ------ 没有<html> ----------
-(void)requestData:(NSInteger)index{
    self.model = [MyPlayerManager defaultManader].musicLists[index];
    NSDictionary *dic = self.model.playInfo;
    self.UrlStr = dic[@"webview_url"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlStr]];
    [self.wView loadRequest:request];
}

-(void)creatWebV{
    self.wView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight - 64 -60 -10)];
    [self.SongWordV addSubview:self.wView];
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
        [_aboveB addTarget:self action:@selector(aboveB:) forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_aboveB];
        //下一首
        _nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextB.frame = CGRectMake(kScreenWidth - 100 ,10, 40, 40);
        [_nextB setImage:[UIImage imageNamed:@"music_icon_next_highlighted@2x.png"] forState:UIControlStateNormal];
        [_nextB addTarget:self action:@selector(nextB:) forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_nextB];
        //
        UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(40,1, kScreenWidth-80, 1)];
        horizontal.backgroundColor = [UIColor grayColor];
        [_playView addSubview:horizontal];
    }
    return _playView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyPlayerManager defaultManader].isPlay = ![MyPlayerManager defaultManader].isPlay;
    [self playAndPause:self.playB];
}

#pragma mark ----- 播放按钮 -----
-(void)playAndPause:(id)sender{
    UIButton *button = sender;
    [[MyPlayerManager defaultManader] playAndPause];
    //如果是播放 让其显示暂停按钮
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        [button setImage:[UIImage imageNamed:@"music_icon_stop_highlighted@2x.png"] forState:UIControlStateNormal];
        [self resumeLayer:self.PlayerView.imageV.layer];
//        [self pauseLayer:self.PlayerView.imageV.layer];
    } else {
        [button setImage:[UIImage imageNamed:@"music_icon_play_highlighted@2x.png"] forState:UIControlStateNormal];
        [self pauseLayer:self.PlayerView.imageV.layer];
//        [self resumeLayer:self.PlayerView.imageV.layer];
    }
}

#pragma mark ----- 上一首歌 -----
-(void)aboveB:(id)sender{
    [[MyPlayerManager defaultManader] lastMusic:self.pType];
    [self reloadViewWithIndex:[MyPlayerManager defaultManader].index];
    [self requestData:[MyPlayerManager defaultManader].index];
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        [_playB setImage:[UIImage imageNamed:@"music_icon_stop_highlighted@2x.png"] forState:UIControlStateNormal];
    } else {
        [_playB setImage:[UIImage imageNamed:@"music_icon_play_highlighted@2x.png"] forState:UIControlStateNormal];
    }
}

#pragma mark ----- 下一首歌 -----
-(void)nextB:(id)sender{
    [[MyPlayerManager defaultManader] nextMusic:self.pType];
    [self reloadViewWithIndex:[MyPlayerManager defaultManader].index];
    NSLog(@"%ld",[MyPlayerManager defaultManader].index);
    [self requestData:[MyPlayerManager defaultManader].index];
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        [_playB setImage:[UIImage imageNamed:@"music_icon_stop_highlighted@2x.png"] forState:UIControlStateNormal];
    } else {
        [_playB setImage:[UIImage imageNamed:@"music_icon_play_highlighted@2x.png"] forState:UIControlStateNormal];
    }
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

#pragma mark ----- 播放方式按钮 -----
-(UIButton *)playWay{
    if (!_playWay) {
        _playWay = [UIButton buttonWithType:UIButtonTypeCustom];
        _playWay.frame = CGRectMake(100,20, KNaviH, KNaviH);
        [_playWay setImage:[UIImage imageNamed:@"顺序播放.png"] forState:UIControlStateNormal];
        [_playWay addTarget:self action:@selector(playwayAction) forControlEvents:UIControlEventTouchUpInside];
        self.wayC = 1;
    }
    return _playWay;
}

-(void)playwayAction{
    self.wayC ++;
    if (self.wayC == 2) {
        [_playWay setImage:[UIImage imageNamed:@"单曲播放.png"] forState:UIControlStateNormal];
        _pType = SinglePlay;
    }
    if (self.wayC == 3) {
        [_playWay setImage:[UIImage imageNamed:@"随机播放.png"] forState:UIControlStateNormal];
        _pType = RandomPlay;
    }
    if (self.wayC == 4) {
        [_playWay setImage:[UIImage imageNamed:@"顺序播放.png"] forState:UIControlStateNormal];
         self.wayC = 1;
        _pType = ListPlay;
    }
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


-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
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
