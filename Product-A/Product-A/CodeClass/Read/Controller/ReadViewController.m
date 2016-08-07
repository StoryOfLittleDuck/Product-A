//
//  ReadViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadListCollectionViewCell.h"
#import "ReadDetailViewController.h"
#import "ReadListViewController.h"
#import "ReadModel.h"
#import "ReadListModel.h"
@interface ReadViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)UIPageControl *pageC;
@property (nonatomic, strong)NSMutableDictionary *parDic;
@property (nonatomic, strong)UICollectionView *collectionV;
@property (nonatomic, strong)NSMutableArray *Arr1;
@property (nonatomic, strong)NSMutableArray *Arr2;
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UITapGestureRecognizer *tap11;
@property (nonatomic, assign)NSInteger index;
@end

@implementation ReadViewController

-(NSMutableArray *)Arr1{
    if (!_Arr1) {
        _Arr1 = [NSMutableArray array];
    }
    return _Arr1;
}

-(NSMutableArray *)Arr2{
    if (!_Arr2) {
        _Arr2 = [NSMutableArray array];
    }
    return _Arr2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- 数据请求 -----
-(void)requestData{
    self.parDic = [@{@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"auth":@"BsdsQiiw9K9DCMVzGMTikDJxQ8auML6E82dsXj1lcWP23tBPTxRY4Pw",@"version":@"3.0.2"}mutableCopy];
    [RequestManager requestWithUrlString:kUrl parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        self.Arr1 = [ReadModel modelConfigureWithJsonDic:dic];
        self.Arr2 = [ReadListModel modelConfigureWithJsonDic:dic];
        
        [self creatScrollerView];
        [self creatPageController];
        [self creatCollection];
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}

#pragma mark ----- 创建滚动视图 -----
-(void)creatScrollerView{
    self.scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60,kScreenWidth, 180)];
    self.scrollV.delegate = self;
    self.scrollV.contentSize = CGSizeMake(kScreenWidth * (self.Arr1.count+1), 180);
    self.scrollV.contentOffset = CGPointMake(kScreenWidth, 0);
    self.scrollV.pagingEnabled = YES;
    self.scrollV.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < self.Arr1.count + 1; i++) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 180)];
        if (i == 0) {
            ReadModel *model = self.Arr1.lastObject;
            self.imageV.userInteractionEnabled = YES;
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.img] completed:nil];
        } else {
            ReadModel *model = self.Arr1[i -1];
            self.index = i -1;
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.img] completed:nil];
            //添加手势
            self.imageV.userInteractionEnabled = YES;
            self.tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [self.imageV addGestureRecognizer:self.tap11];
        }
        [self.scrollV addSubview:self.imageV];
    }
    [self.view addSubview:self.scrollV];
}

-(void)creatPageController{
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 210, 50, 30)];
    self.pageC.numberOfPages = self.Arr1.count;
    self.pageC.currentPage = 0;
    self.pageC.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageC.pageIndicatorTintColor = [UIColor grayColor];
    self.pageC.backgroundColor = [UIColor clearColor];
    [self.pageC addTarget:self action:@selector(page:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageC];
    [self timer];
}

#pragma mark ----- 轻拍手势按钮 -----
-(void)tap:(UITapGestureRecognizer *)sender{
    ReadDetailViewController *RDVC = [[ReadDetailViewController alloc]init];
    for (int i = 1; i < self.Arr1.count + 1; i ++) {
        if (self.scrollV.contentOffset.x == i * kScreenWidth) {
            ReadModel *model = self.Arr1[i - 1];
            RDVC.url = model.url;
        }
        if (self.scrollV.contentOffset.x < i * kScreenWidth) {
            ReadModel *model = self.Arr1.firstObject;
            RDVC.url = model.url;
        }
    }
    [self.navigationController pushViewController:RDVC animated:YES];
}



#pragma mark ----- 创建ColletionView -----
-(void)creatCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
     self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 240, kScreenWidth, kScreenHeight - 240) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(kScreenHeight / 3 - 121, (kScreenHeight-280)/3);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionV];
    [self.collectionV registerClass:[ReadListCollectionViewCell class] forCellWithReuseIdentifier:@"listCell"];
}

#pragma mark ----- collectionView的协议方法 -----
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.Arr2.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadListViewController *RLVC = [[ReadListViewController alloc]init];
    ReadListModel *model = self.Arr2[indexPath.row];
    RLVC.str = model.name;
    RLVC.type = [NSString stringWithFormat:@"%d",[model.type intValue]];
    [self.navigationController pushViewController:RLVC animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadListModel *model = self.Arr2[indexPath.row];
    ReadListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    return cell;
}

#pragma mark ----- 无限滚动视图的方法 -----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x > self.Arr1.count * kScreenWidth) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (offset.x < 0) {
        [scrollView setContentOffset:CGPointMake(self.Arr1.count * kScreenWidth, 0) animated:NO];
    }
}

-(void)page:(UIPageControl *)page{
    [self.scrollV setContentOffset:CGPointMake(page.currentPage * kScreenWidth, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint p = self.scrollV.contentOffset;
    NSInteger page = p.x/kScreenWidth;
    self.pageC.currentPage = page;
    self.pageC.currentPage = page -1 < 0 ? self.Arr1.count - 1: page-1;
}

#pragma mark ----- 计时器 -----
-(NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark ----- 计时器方法 -----
-(void)nextpage{
    NSInteger page = self.pageC.currentPage;
    if (page == self.Arr1.count -1) {
        [self.scrollV setContentOffset:CGPointMake(0 , 0) animated:NO];
        page = 0;
        [self.scrollV setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    } else {
        page ++;
        [self.scrollV setContentOffset:CGPointMake(kScreenWidth * (page +1) , 0) animated:YES];
    }
    self.pageC.currentPage =page;
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
