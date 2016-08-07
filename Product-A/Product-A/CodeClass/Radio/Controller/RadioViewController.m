//
//  RadioViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RadioViewController.h"
#import "RootViewController.h"
#import "DTableViewCell.h"
#import "CCollectionViewCell.h"
#import "RadioListViewController.h"
#import "Model.h"
#define w self.view.frame.size.width
@interface RadioViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UIScrollView *scrollV;
@property (nonatomic ,strong)UIPageControl *pageC;
@property (nonatomic ,strong)UICollectionView *collectionV;
@property (nonatomic ,strong)UITableView *tableV;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSMutableArray *Carray;
@property (nonatomic ,strong)NSMutableArray *Darray;
@property (nonatomic ,strong)NSMutableArray *searchArr;
@property (nonatomic ,strong)NSMutableDictionary *parDic;
@property (nonatomic ,strong)NSMutableDictionary *parDic1;
@property (nonatomic ,strong)UIImageView *imageV;
@property (nonatomic, strong)UIButton *SingB;
@property (nonatomic, strong)UIButton *MusicB;
@property (nonatomic, strong)UILabel *SingL;
@property (nonatomic ,strong)NSTimer *timer;
@end

@implementation RadioViewController
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(NSMutableArray *)Carray{
    if (!_Carray) {
        _Carray = [NSMutableArray array];
    }
    return _Carray;
}

-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

-(NSMutableArray *)Darray{
    if (!_Darray) {
        _Darray = [NSMutableArray array];
    }
    return _Darray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self animationA];
    
    
    
}

-(void)animationA{
    if ([MyPlayerManager defaultManader].isPlay == YES) {
        //动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.duration = 8;
        animation.repeatCount = FLT_MAX;
        [_MusicB.layer addAnimation:animation forKey:nil];
        
        MyPlayerManager *manager = [MyPlayerManager defaultManader];
        manager.chang = ^(BOOL aaa){
            if (aaa == NO) {
                [self pauseLayer:_MusicB.layer];
            }else {
                [self resumeLayer:_MusicB.layer];
            }
        };
    }
}


-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] -    pausedTime;
    layer.beginTime = timeSincePause;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.a1 = 1;
    [MyPlayerManager defaultManader].first = self.a1;
    //音乐符
    //评论按钮
    _MusicB = [UIButton buttonWithType:UIButtonTypeCustom];
    _MusicB.frame = CGRectMake(kScreenWidth /2 +30 , 25, 30, 30);
    [_MusicB setImage:[UIImage imageNamed:@"音乐.png"] forState:UIControlStateNormal];
    [_MusicB addTarget:self action:@selector(musicA) forControlEvents:UIControlEventTouchUpInside];
    RootViewController *rootVC = [[RootViewController alloc]init];
    rootVC.music =^(BOOL play){
        if (play == YES) {
            //动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
            animation.duration = 8;
            animation.repeatCount = FLT_MAX;
            [_MusicB.layer addAnimation:animation forKey:nil];
        } else {
     
        }
        [self.view addSubview:self.MusicB];
    };
    [self.view addSubview:self.MusicB];
    //主播按钮
    _SingB = [UIButton buttonWithType:UIButtonTypeCustom];
    _SingB.frame = CGRectMake(kScreenWidth /2 + 70, 25, 30, 30);
    [_SingB setImage:[UIImage imageNamed:@"话筒.png"] forState:UIControlStateNormal];
    [_SingB addTarget:self action:@selector(singA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SingB];
    _SingL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 100, 25, 100, 30)];
    _SingL.text = @"我要当主播";
    [self.view addSubview:self.SingL];
    [self requestData];
    [self requesetData1];
    NSLog(@"%@",self.searchArr);
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建轮播图 -----
-(void)creatScrollView{
    if (self.array.count == 0) {
        return;
    }
    self.scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, w, 180)];
    self.scrollV.contentSize = CGSizeMake(w * (self.array.count + 1), 200);
    self.scrollV.contentOffset = CGPointMake(w, 0);
    self.scrollV.delegate = self;
    self.scrollV.pagingEnabled = YES;
    self.scrollV.showsHorizontalScrollIndicator = NO;
    if (self.array.count == 1) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, 200)];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.array[0]] completed:nil];
    }
    for (int i = 0; i < self.array.count + 1; i++) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * w, 0, w, 200)];
        if (i == 0) {
            Model *model = self.array.lastObject;
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
        } else  {
            Model *model = self.array[i-1];
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
            //添加手势
            self.imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.imageV addGestureRecognizer:tap];
        }
        [self.scrollV addSubview:self.imageV];
    }
    [self.view addSubview:self.scrollV];
    [MyPlayerManager defaultManader].block1 = ^(MusicModel *model){
        self.model = model;
    };
}

-(void)creatPageController{
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(120, 210, 145, 30)];
    self.pageC.numberOfPages = self.array.count;
    self.pageC.currentPage = 0;
    self.pageC.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageC.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageC.backgroundColor = [UIColor clearColor];
    [self.pageC addTarget:self action:@selector(page:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageC];
    [self timer];
}

#pragma mark ----- 手势方法 -----
-(void)tapAction:(UITapGestureRecognizer *)sender{
    RadioListViewController *RLVC = [[RadioListViewController alloc]init];
    for (int i = 1; i < self.array.count + 1; i ++) {
        if (self.scrollV.contentOffset.x == i * kScreenWidth) {
            Model *model = self.array[i - 1];
            RLVC.strTitle = model.title;
            RLVC.strPar = model.radioid;
        }
        if (self.scrollV.contentOffset.x < i * kScreenWidth && self.scrollV.contentOffset.x > (i -1)*kScreenWidth) {
            Model *model = self.array[i - 1];
            RLVC.strTitle = model.title;
            RLVC.strPar = model.radioid;
        }
    }
    [MyPlayerManager defaultManader].isZT = YES;
    [self.navigationController pushViewController:RLVC animated:YES];
}

#pragma mark ----- 创建collectionView -----
-(void)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 240, w +10, 170) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(120, 150);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV registerClass:[CCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionV];
}

#pragma mark ----- 创建TableView -----
-(void)creatTableView{
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 410, w, self.view.frame.size.height - 350) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerNib:[UINib nibWithNibName:@"DTableViewCell" bundle:nil] forCellReuseIdentifier:@"Dcell"];
    [self.view addSubview:self.tableV];
}

#pragma mark ----- 无限轮播图方法 -----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset =scrollView.contentOffset;
    if (offset.x > self.array.count * w) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (offset.x < 0) {
        [scrollView setContentOffset:CGPointMake(self.array.count * w, 0) animated:NO];
    }
    
}

-(void)page:(UIPageControl *)page{
    [self.scrollV setContentOffset:CGPointMake(page.currentPage * w, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint p = self.scrollV.contentOffset;
    NSInteger page = p.x/w;
    self.pageC.currentPage = page;
    self.pageC.currentPage = page -1 < 0 ? self.array.count - 1: page-1;
}

#pragma mark ----- 创建计时器 -----
-(NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark ----- 计时器方法 -----
-(void)nextpage{
    NSInteger page = self.pageC.currentPage;
    if (page == self.array.count -1) {
        [self.scrollV setContentOffset:CGPointMake(0 , 0) animated:NO];
        page = 0;
        [self.scrollV setContentOffset:CGPointMake(w, 0) animated:YES];
    } else {
        page ++;
        [self.scrollV setContentOffset:CGPointMake(w * (page +1) , 0) animated:YES];
    }
    self.pageC.currentPage =page;
}

#pragma mark ----- 数据请求 -----
-(void)requestData{
    self.parDic = [@{@"start":@"0",@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"limit":@"10",@"auth":@"",@"version":@"3.0.2"}mutableCopy];
    [RequestManager requestWithUrlString:kRadioURL parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        self.array = [Model modelConfigureWithJsonDic:dic];
        self.Carray = [CModel CModelConfigureWithJsonDic:dic];
        for (Model *model in self.array) {
            [self.searchArr addObject:model.title];
        }
        for (CModel *model in self.Carray) {
            [self.searchArr addObject:model.title];
        }
//        NSLog(@"%@",self.searchArr);
        [self creatScrollView];
        [self creatPageController];
        [self creatCollectionView];
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}


-(void)requesetData1{
    self.parDic1 = [@{@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo",@"client":@"1",@"deviceid":@"6D4DD967-5EB2-40E2-A202-37E64F3BEA31",@"limit":@"10",@"start":@"0",@"version":@"3.0.6"} mutableCopy];
    [RequestManager requestWithUrlString:kRadioListURL parDic:self.parDic1 requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic1);
        self.Darray = [DModel DModelConfigureWithJsonDic:dic1];
        for (DModel *model in self.Darray) {
            [self.searchArr addObject:model.title];
        }
        [self creatTableView];
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
    
}

#pragma mark ----- collectionView协议方法 -----
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CModel *model = self.Carray[indexPath.row];
    CCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RadioListViewController *RLVC = [[RadioListViewController alloc]init];
    CModel *model = self.Carray[indexPath.row];
    RLVC.strTitle = model.title;
    RLVC.strPar = model.radioid;
    [MyPlayerManager defaultManader].isZT = YES;
    [self.navigationController pushViewController:RLVC animated:YES];
}

#pragma mark ----- tableView协议方法 -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DModel *model = self.Darray[indexPath.row];
    DTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dcell" forIndexPath:indexPath];
    [cell cellConfigureWithDModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioListViewController *RLVC = [[RadioListViewController alloc]init];
            DModel *model = self.Darray[indexPath.row];
            RLVC.strTitle = model.title;
            RLVC.strPar = model.radioid;
    [MyPlayerManager defaultManader].isZT = YES;
    [self.navigationController pushViewController:RLVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 40)];
    label.text = @"全部电台·All Radios ——————————————";
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor grayColor];
    return label;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.Carray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Darray.count +2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath == 0) {
//        return <#expression#>
//    }
    return 150;
}

-(void)singA{

}

-(void)musicA{

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
