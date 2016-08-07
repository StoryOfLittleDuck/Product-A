//
//  RootViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RootViewController.h"
#import "RightViewController.h"
#import "MusicCollectionViewController.h"
#import "RootTableViewCell.h"
#import "RegistViewController.h"
#import "LoginViewController.h"
#define KCAGradientLayerH (kScreenWidth/ 3.0)
#define IOS8    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>
@property (nonatomic, strong)NSArray *controllers;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *imageA;
@property (nonatomic, strong)NSArray *searchArr;
@property (nonatomic, assign)BOOL isCellSelected;
@property (nonatomic, strong)RightViewController *rightVC;
@property (nonatomic, strong)UINavigationController *naVC;
@property (nonatomic, strong)UISearchController *searchVC;
@property (nonatomic, strong)UITableView *searchT;
@property (nonatomic, strong)UIView *MusicV;
@property (nonatomic, strong)UIView *headV;
@property (nonatomic, strong)UIImageView *headImageV;
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UITextField *searchTF;
@property (nonatomic, strong)UILabel *label1;
@property (nonatomic, strong)UILabel *label2;
@property (nonatomic, strong)UILabel *loginL;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *registB;
@property (nonatomic, strong)UIButton *loginB;
@property (nonatomic, strong)UIButton *downloadB;
@property (nonatomic, strong)UIButton *collectB;
@property (nonatomic, strong)UIButton *messageB;
@property (nonatomic, strong)UIButton *setB;
@end

@implementation RootViewController
// 优先状态栏样式(更改状态栏)
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.MusicV];
//    [self.view addSubview:self.searchVC];
    [self initGradientLayer];
    [self.view addSubview:self.headV];
    [self initTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *aa = [UserInfoManager getUserIcon];
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:aa] completed:nil];
    NSString *bb = [UserInfoManager getUserName];
    self.loginL.text = bb;
}

#pragma mark ----- 创建头像视图 -----
-(UIView *)headV{
    if (!_headV) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0,20,kScreenWidth,KCAGradientLayerH +50)];
        _headV.backgroundColor = [UIColor clearColor];
        //头像
        _headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
        _headImageV.backgroundColor = [UIColor whiteColor];
        _headImageV.layer.masksToBounds = YES;
        _headImageV.layer.cornerRadius = 30;
        _headImageV.image = [UIImage imageNamed:@"用户.png"];
        
        //登录注册/按钮
        _registB = [UIButton buttonWithType:UIButtonTypeCustom];
        _registB.frame = CGRectMake(144, 50, 40, 30);
        [_registB setTitle:@"注册" forState:UIControlStateNormal];
        [_registB addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        _loginB = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginB.frame = CGRectMake(100, 50, 40, 30);
        [_loginB setTitle:@"登录" forState:UIControlStateNormal];
        [_loginB addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(141, 54, 2, 22)];
        vertical.backgroundColor = [UIColor whiteColor];
        //下载按钮
        _downloadB = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadB.frame = CGRectMake(18, 100, 30, 30);
        _downloadB.layer.masksToBounds = YES;
        _downloadB.layer.cornerRadius = 15;
        _downloadB.backgroundColor = [UIColor whiteColor];
        [_downloadB setImage:[UIImage imageNamed:@"下载 (2).png"] forState:UIControlStateNormal];
        [_downloadB addTarget:self action:@selector(downloadA) forControlEvents:UIControlEventTouchUpInside];
        //收藏按钮
        _collectB = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectB.frame = CGRectMake((kScreenWidth - 48)/ 4 +18, 100, 30, 30);
        _collectB.layer.masksToBounds = YES;
        _collectB.layer.cornerRadius = 15;
        _collectB.backgroundColor = [UIColor whiteColor];
        [_collectB setImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
        [_collectB addTarget:self action:@selector(collectA) forControlEvents:UIControlEventTouchUpInside];
        //信息按钮
        _messageB = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageB.frame = CGRectMake((kScreenWidth - 48)/ 2 +18, 100, 30, 30);
        _messageB.layer.masksToBounds = YES;
        _messageB.layer.cornerRadius = 15;
        _messageB.backgroundColor = [UIColor whiteColor];
        [_messageB setImage:[UIImage imageNamed:@"信息.png"] forState:UIControlStateNormal];
        [_messageB addTarget:self action:@selector(messageA) forControlEvents:UIControlEventTouchUpInside];
        //修改按钮
        _setB = [UIButton buttonWithType:UIButtonTypeCustom];
        _setB.frame = CGRectMake((kScreenWidth - 48)/ 4*3 +18, 100, 30, 30);
        _setB.layer.masksToBounds = YES;
        _setB.layer.cornerRadius = 15;
        _setB.backgroundColor = [UIColor whiteColor];
        [_setB setImage:[UIImage imageNamed:@"写作.png"] forState:UIControlStateNormal];
        [_setB addTarget:self action:@selector(setA) forControlEvents:UIControlEventTouchUpInside];
        //搜索栏
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(18, 145, 300, 30)];
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 15;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索 (1).png"]];
        _searchTF.backgroundColor = [UIColor grayColor];
        [_headV addSubview:_searchTF];
        [_headV addSubview:_setB];
        [_headV addSubview:_messageB];
        [_headV addSubview:_collectB];
        [_headV addSubview:_downloadB];
        [_headV addSubview:vertical];
        [_headV addSubview:_registB];
        [_headV addSubview:_loginB];
        [_headV addSubview:_headImageV];
        [_headV addSubview:self.loginL];
    }
    return _headV;
}

#pragma mark ----- 搜索标签 -----
-(UISearchController *)searchVC{
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
        //设置显示搜索的显示器
        _searchVC.searchResultsUpdater = self;
        //自适应屏幕大小
        [_searchVC.searchBar sizeToFit];
        //设置开始搜索时，背景显示与否
        _searchVC.dimsBackgroundDuringPresentation = NO;
        _searchVC.searchBar.delegate = self;
        //searchController的代理
        _searchVC.delegate = self;
    }
    return _searchVC;
}

#pragma mark ----- UISearchResultUpdating -----
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//用谓词进行检索
//谓词检索是开发中常用的搜索方式  是系统自带的搜索方式  减轻开发人员压力
//谓词搜索模式  固定格式写法 self contains [cd] %@
//@""里边 填写self contains [cd] searchBar.text
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchController.searchBar.text];
//通过谓词检索 将检验出来的数据 从原有数据中提取出来 放到新的数组中 也就是从self.dataArray中的数据检索出来，放到监测后的数组中self.arr中
//    self.searchVC  = [NSMutableArray alloc]in
    _isSearch = YES;
    [self.searchT reloadData];
    
}

#pragma mark ----- UISearchBarDelegate -----
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearch = NO;
    [self.searchT reloadData];
}

#pragma mark -- UISearchControllerDelegate
//将要模态出searchController时触发
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"将要模态出现searchController");
    
}
//已经模态出searchController时触发
- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"已经模态出现searchController");
}
//将要模态消失searchController时触发
- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"将要模态消失searchController");
    
}
//已经模态消失searchController时触发
- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"已经模态消失searchController");
    _isSearch = NO;
    [self.searchT reloadData];
}

//模态推出searchController 时触发, 点击搜索弹出搜索框之前触发
- (void)presentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"搜索框出现之前触发");
}


#pragma mark ----- 搜索标签 -----
-(UITableView *)searchT{
    if (!_searchT) {
        _searchT = [[UITableView alloc]initWithFrame:CGRectMake(18, 175, 300, 30) style:UITableViewStylePlain];
    }
    return _searchT;
}

#pragma mark ----- 登录标签 -----
-(UILabel *)loginL{
    if (!_loginL) {
        _loginL = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 30)];
        _loginL.textColor = [UIColor whiteColor];
        _loginL.text = @"未登录";
        _loginL.backgroundColor = [UIColor clearColor];
    }
    return _loginL;
}

-(void)registAction{
//    RegistViewController *RVC =[[RegistViewController alloc]init];
//
//    [self presentViewController:RVC animated:YES completion:nil];
}

-(void)loginAction{
    LoginViewController *LVC =[[LoginViewController alloc]init];
    LVC.block11 =^(NSString *name){
        self.loginL.text = name;
    };
    LVC.loginSuccess =^(NSString *str){
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:str] completed:nil];
    };
    
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:LVC];
    navc.navigationBar.hidden = YES;
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark ----- 打开下载界面 -----
-(void)downloadA{
    MusicCollectionViewController *MCVC = [[MusicCollectionViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:MCVC];
    naVC.navigationBar.hidden = YES;
    [self presentViewController:naVC animated:YES completion:nil];
}

-(void)collectA{

}

-(void)messageA{

}

-(void)setA{

}

#pragma mark ----- 歌曲栏 -----
-(UIView *)MusicV{
    if (!_MusicV) {
        _MusicV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64)];
        _MusicV.backgroundColor = PKCOLOR(40, 40, 40);
        [MyPlayerManager defaultManader].block = ^(MusicModel *model){
            self.model = model;
            _MusicV.backgroundColor = [UIColor blackColor];
            _label1.textColor = [UIColor whiteColor];
            _label2.textColor = [UIColor whiteColor];
            [_imageV sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg] completed:nil];
             _label1.text = self.model.title;
            NSDictionary *dic = self.model.playInfo;
            NSDictionary *Dic = dic[@"authorinfo"];
            _label2.text = Dic[@"uname"];
            [_button setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
            _button.backgroundColor = [UIColor whiteColor];
            [_button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        };
        [MyPlayerManager defaultManader].isblock =^(BOOL isPlay){
            self.isPlayer = isPlay;
            if (self.isPlayer == YES) {
                [_button setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
            } else {
                [_button setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
            }
        };
        //歌曲图片
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 54, 44)];
        _imageV.backgroundColor = PKCOLOR(40, 40, 40);
       
        [_MusicV addSubview:_imageV];
        //歌名
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 180, 20)];
       
        _label1.font = [UIFont fontWithName:@"Helvetica" size:18];
        _label1.textColor = PKCOLOR(40, 40, 40);
        [_MusicV addSubview:_label1];
        //题目
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 180, 20)];
        
        _label2.font = [UIFont fontWithName:@"Helvetica" size:12];
        _label2.textColor = PKCOLOR(40, 40, 40);
        [_MusicV addSubview:_label2];
        //play
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(kScreenWidth / 3*2 , 10, 44, 44);
        _button.backgroundColor = PKCOLOR(40, 40, 40);
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 22;
        [_MusicV addSubview:_button];
        }
    return _MusicV;
}

#pragma mark ----- 开关代码 -----
-(void)action{
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        [[MyPlayerManager defaultManader] playAndPause];
        [_button setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
}
     else {
        [[MyPlayerManager defaultManader] playAndPause];
        [_button setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    }

    MyPlayerManager *manager = [MyPlayerManager defaultManader];
    manager.chang([MyPlayerManager defaultManader].isPlay);
}

-(void)initGradientLayer{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = CGRectMake(0, 20, kScreenWidth,KCAGradientLayerH +50);
    gradientLayer.colors = @[(id)PKCOLOR(180, 180, 180).CGColor, (id)PKCOLOR(100, 90, 100).CGColor, (id)PKCOLOR(40, 40, 40).CGColor];
    [self.view.layer addSublayer:gradientLayer];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootCell" forIndexPath:indexPath];
    cell.textFile.text = _titles[indexPath.row];
    NSString *imageStr = _imageA[indexPath.row];
    cell.textFile.textColor = PKCOLOR(80, 80, 80);
    cell.textFile.font = [UIFont systemFontOfSize:cell.height/4.0];
    cell.imageV.image = [UIImage imageNamed:imageStr];
    cell.imageV.tintColor = PKCOLOR(80, 80, 80);
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = PKCOLOR(40, 40, 40);
    if (indexPath.row == 0 && !_isCellSelected) {
        cell.textFile.textColor = PKCOLOR(240, 240, 240);
        _isCellSelected = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textFile.textColor = PKCOLOR(240, 240, 240);
    cell.imageV.tintColor  = PKCOLOR(240, 240, 240);
    if ([_rightVC isMemberOfClass:[NSClassFromString(_controllers[indexPath.row])class] ]) {
        [_rightVC changeFrameWithType:MoveTypeRight];
        return;
    }
    [_naVC.view removeFromSuperview];
    //初始化子视图
    _rightVC = [[NSClassFromString(_controllers[indexPath.row])alloc]init];
    _rightVC.titleLabel.text = _titles[indexPath.row];
    _naVC = [[UINavigationController alloc]initWithRootViewController:_rightVC];
    _naVC.navigationBar.hidden = YES;
    [self.view addSubview:_naVC.view];
//    _naVC.view.frame = CGRectMake(kScreenWidth - kMoveDistance, 0, kScreenWidth, kScreenHeight);
    CGRect newFrame = _naVC.view.frame;
    newFrame.origin.x = kScreenWidth - kMoveDistance;
    _naVC.view.frame = newFrame;
    [_rightVC changeFrameWithType:MoveTypeLeft];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    RootTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textFile.textColor = PKCOLOR(80, 80, 80);
    cell.backgroundColor = PKCOLOR(40, 40, 40);
}

#pragma mark ----- 创建tableView -----
-(void)initTableView{
    _controllers = @[@"RadioViewController",@"ReadViewController",@"CommunityViewController",@"ProductViewController",@"SettingViewController"];
    _titles = @[@"电台",@"阅读",@"社区",@"良品",@"设置"];
    _imageA = @[@"Pro_电台.png",@"阅读.png",@"社区管理.png",@"品.png",@"设置.png"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,50+ 20 + KCAGradientLayerH, kScreenWidth, kScreenHeight - 20 - KCAGradientLayerH - 64 -50) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = PKCOLOR(40, 40, 40);
    tableView.rowHeight = tableView.height /_titles.count;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    //初始化子视图
    _rightVC = [[NSClassFromString(_controllers[0])alloc]init];
    _rightVC.titleLabel.text = _titles[0];
    _naVC = [[UINavigationController alloc]initWithRootViewController:_rightVC];
    _naVC.navigationBar.hidden = YES;
    [self.view addSubview:_naVC.view];
    [tableView registerNib:[UINib nibWithNibName:@"RootTableViewCell" bundle:nil] forCellReuseIdentifier:@"rootCell"];
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
