//
//  ReadListViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadListViewController.h"
#import "ReadListTableViewCell.h"
#import "ReadLDViewController.h"
#import "ReadDetailModel.h"
@interface ReadListViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableDictionary *parDic;
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)UITableView *HotTableV;
@property (nonatomic, strong)UITableView *NewTableV;
@property (nonatomic, strong)NSMutableArray *HotArr;
@property (nonatomic, strong)NSMutableArray *NewArr;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UIView *cV;
@property (nonatomic, strong)UIButton *NewButton;
@property (nonatomic, strong)UIButton *HotButton;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, assign)BOOL NewIsLoad;
@property (nonatomic, assign)BOOL sortType;//YES hot
@property (nonatomic, assign) NSInteger limitIndex;
@end

@implementation ReadListViewController

-(NSMutableArray *)HotArr{
    if (!_HotArr) {
        _HotArr = [NSMutableArray array];
    }
    return  _HotArr;
}

-(NSMutableArray *)NewArr{
    if (!_NewArr) {
        _NewArr = [NSMutableArray array];
    }
    return _NewArr;
}

-(NSMutableDictionary *)parDic{
    if (!_parDic) {
        _parDic = [NSMutableDictionary dictionary];
    }
    return _parDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.cV = [[UIView alloc]initWithFrame:CGRectMake(200, 58, 50, 2)];
    self.cV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.cV];
    
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60,kScreenWidth , kScreenHeight-60)];
    _scrollV.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - 60);
    _scrollV.delegate = self;
    _scrollV.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollV];
    
    [self titleL];
    [self button];
    [self NewButton];
    [self HotButton];
    [self creatHotTableView];
    [self creatNewTableView];

    self.limitIndex = 1;
//    self.sortType = NO;
    //new
    self.NewTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.NewArr removeAllObjects];
        self.newStart = 0;
        self.NewIsLoad = YES;
        self.sortType = NO;
        [self requestDataWithSort:@"addtime" Start:_newStart];
    }];
    self.NewTableV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.newStart = self.limitIndex * 10;
        self.NewIsLoad = YES;
        self.sortType = NO;
        [self requestDataWithSort:@"addtime" Start:_newStart];
    }];
    
    //hot
    self.HotTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.HotArr removeAllObjects];
        self.hotStart = 0;
        self.NewIsLoad = NO;
        self.sortType = YES;
        [self requestDataWithSort:@"hot" Start:_hotStart];
    }];
    self.HotTableV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.hotStart = 10 * self.limitIndex;
        self.NewIsLoad = NO;
        self.sortType = YES;
        [self requestDataWithSort:@"hot" Start:_hotStart];
    }];
    [self.NewTableV.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建tableView -----
-(void)creatHotTableView{
        self.HotTableV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth , 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStylePlain];
        self.HotTableV.delegate = self;
        self.HotTableV.dataSource = self;
        self.HotTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.HotTableV registerNib:[UINib nibWithNibName:@"ReadListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    [self.scrollV addSubview:self.HotTableV];
}

-(void)creatNewTableView{
        self.NewTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStylePlain];
        self.NewTableV.delegate = self;
        self.NewTableV.dataSource = self;
        self.NewTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.NewTableV registerNib:[UINib nibWithNibName:@"ReadListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    [self.scrollV addSubview:self.NewTableV];
}


-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(45, 20, 120, 40)];
        _titleL.text = self.str;
        [self.view addSubview:self.titleL];
    }
    return _titleL;
}

#pragma mark ----- 返回按钮 -----
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,20, KNaviH, KNaviH);
        [_button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button];
    }
    return _button;
}

#pragma mark ----- NEW按钮 -----
-(UIButton *)NewButton{
    if (!_NewButton) {
        _NewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _NewButton.frame = CGRectMake(200,20, 50, KNaviH);
        _NewButton.backgroundColor = [UIColor blackColor];
        [_NewButton setTitle:@"New" forState:UIControlStateNormal];
        [_NewButton addTarget:self action:@selector(NewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.NewButton];
    }
    return _NewButton;
}

-(void)NewAction:(id)sender{
    _NewButton.backgroundColor = [UIColor blackColor];
    _HotButton.backgroundColor = [UIColor grayColor];
    self.sortType = NO;
    [self requestDataWithSort:@"addtime" Start:_newStart];
    [self.scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark ----- Hot按钮 -----
-(UIButton *)HotButton{
    if (!_HotButton) {
        _HotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _HotButton.frame = CGRectMake(250,20, 50, KNaviH);
        _HotButton.backgroundColor = [UIColor grayColor];
        [_HotButton setTitle:@"Hot" forState:UIControlStateNormal];
        [_HotButton addTarget:self action:@selector(HotAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.HotButton];
    }
    return _HotButton;
}

-(void)HotAction:(id)sender{
    _HotButton.backgroundColor = [UIColor blackColor];
    _NewButton.backgroundColor = [UIColor grayColor];
    self.sortType = YES;
    [self requestDataWithSort:@"hot" Start:_hotStart];
    [self.scrollV setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark ----- 按钮方法 -----
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- 数据请求 -----
-(void)requestDataWithSort:(NSString *)sort Start:(NSInteger)start{
    self.parDic = [@{@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"typeid":self.type,@"client":@"1",@"sort":sort,@"limit":[NSString stringWithFormat:@"%ld", self.limitIndex * 10],@"version":@"3.0.2",@"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P0",@"start":[NSString stringWithFormat:@"%ld",start]}mutableCopy];
    [RequestManager requestWithUrlString:kListUrl parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        NSDictionary *Dic = dic[@"data"];
        NSString *s = [NSString stringWithFormat:@"%@",Dic[@"total"]];
        if ([s isEqualToString:@"0"])
        {
            NSLog(@"没有更多数据");
            [self.HotTableV.mj_footer endRefreshing];
            [self.NewTableV.mj_footer endRefreshing];
            return;
        }
       
        if (start == 0)
        {
            // 把数组里面的元素全部清空掉
            [self.HotArr removeAllObjects];
            [self.NewArr removeAllObjects];
        }
        
        NSArray *array = [ReadDetailModel ModelConfigureWithJsonDic:dic];
        for (ReadDetailModel *model in array)
        {
            if (self.sortType == YES) {
                [self.HotArr addObject:model];
            } else if (self.sortType == NO){
                [self.NewArr addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_sortType == YES) {
                [self.HotTableV reloadData];
            }else if (_sortType == NO){
                [self.NewTableV reloadData];
            }
            [self.HotTableV.mj_header endRefreshing];
            [self.HotTableV.mj_footer endRefreshing];
            [self.NewTableV.mj_header endRefreshing];
            [self.NewTableV.mj_footer endRefreshing];
        });
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}

#pragma mark ----- tableView协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _sortType == YES ? self.HotArr.count : self.NewArr.count;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadDetailModel *model = [[ReadDetailModel alloc]init];
    if (self.sortType == YES) {
        model = self.HotArr[indexPath.row];
    } else if (self.sortType == NO) {
        model = self.NewArr[indexPath.row];
    }
    ReadListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    return  cell;
}



#pragma mark ----- 跳转 -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadLDViewController *RLDVC = [[ReadLDViewController alloc]init];
    ReadDetailModel *model = [[ReadDetailModel alloc]init];
    if (self.sortType == YES) {
        model = self.HotArr[indexPath.row];
        RLDVC.url = model.ider;
        [self.navigationController pushViewController:RLDVC animated:YES];
    } else if (self.sortType == NO) {
        model = self.NewArr[indexPath.row];
        RLDVC.url = model.ider;
        [self.navigationController pushViewController:RLDVC animated:YES];
    }
}

#pragma mark ----- scrollView滑动方法 -----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        if (scrollView.contentOffset.x == scrollView.width && _NewIsLoad == YES) {
            [self.HotTableV.mj_header beginRefreshing];
        }
        CGPoint newCenter = _cV.center;
        if (scrollView.contentOffset.x == 0) {
            _NewButton.backgroundColor = [UIColor blackColor];
            _HotButton.backgroundColor = [UIColor grayColor];
            newCenter.x = _NewButton.center.x;
        }else if (scrollView.contentOffset.x == scrollView.width){
            _NewButton.backgroundColor = [UIColor grayColor];
            _HotButton.backgroundColor = [UIColor blackColor];
            newCenter.x = _HotButton.center.x;
        }
        CGFloat distance = _HotButton.center.x - _NewButton.center.x;
        CGFloat scale = scrollView.contentOffset.x/scrollView.width;
        _cV.center = CGPointMake(_NewButton.center.x + distance * scale, _cV.center.y);
    }
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
