//
//  CommunityViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityDetailViewController.h"
#import "CommunityTableViewCell.h"
#import "CommunityModel.h"
@interface CommunityViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *cV;
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)UITableView *HotTableV;
@property (nonatomic, strong)UITableView *NewTableV;
@property (nonatomic, strong)NSMutableArray *HotArr;
@property (nonatomic, strong)NSMutableArray *NewArr;
@property (nonatomic, assign)BOOL NewIsLoad;
@property (nonatomic, assign)BOOL sortType;//YES hot
@property (nonatomic, assign)NSInteger limitIndex;
@property (nonatomic, strong)NSMutableDictionary *parDic;
@property (nonatomic, strong)UISegmentedControl *sgControl;
@end

@implementation CommunityViewController
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
    [self.view addSubview:self.headView];
    [self.view addSubview:self.scrollV];
    self.cV = [[UIView alloc]initWithFrame:CGRectMake(200, 58, 50, 2)];
    self.cV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.cV];
    [self creatHotTableView];
    [self creatNewTableView];
    self.limitIndex =1;
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
    [self.HotTableV.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建选择视图 -----
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, 50)];
        _sgControl =[[UISegmentedControl alloc]initWithItems:@[@"Hot",@"New"]];
        _sgControl.selectedSegmentIndex = 0;
        //设置位置
        _sgControl.frame = CGRectMake(kScreenWidth/2 -60, 10, 120, 30);
        _sgControl.tintColor = PKCOLOR(48, 128, 0);
        [_sgControl addTarget:self action:@selector(sgAction) forControlEvents:UIControlEventValueChanged];
        [_headView addSubview:_sgControl];
    }
    return _headView;
}

-(void)sgAction{
NSInteger Index = _sgControl.selectedSegmentIndex;
    switch (Index) {
        case 0:
            self.sortType = YES;
            [self requestDataWithSort:@"hot" Start:_hotStart];
            [self.scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            self.sortType = NO;
            [self requestDataWithSort:@"addtime" Start:_newStart];
            [self.scrollV setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark ----- 创建滚动视图 -----
-(UIScrollView *)scrollV{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 110,kScreenWidth , kScreenHeight-110)];
        _scrollV.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - 60);
        _scrollV.delegate = self;
        _scrollV.pagingEnabled = YES;
    }
    return _scrollV;
}

#pragma mark ----- scrollView滑动方法 -----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        if (scrollView.contentOffset.x == scrollView.width && _NewIsLoad == NO) {
            [self.NewTableV.mj_header beginRefreshing];
        }
        if (scrollView.contentOffset.x == 0) {
            _sgControl.selectedSegmentIndex = 0;
        }else if (scrollView.contentOffset.x == scrollView.width){
             _sgControl.selectedSegmentIndex = 1;
        }
        
    }
}


#pragma mark ----- 创建tableView -----
-(void)creatHotTableView{
    self.HotTableV = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStylePlain];
    self.HotTableV.delegate = self;
    self.HotTableV.dataSource = self;
    self.HotTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.HotTableV registerNib:[UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil] forCellReuseIdentifier:@"tCell"];
    [self.scrollV addSubview:self.HotTableV];
}

-(void)creatNewTableView{
    self.NewTableV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStylePlain];
    self.NewTableV.delegate = self;
    self.NewTableV.dataSource = self;
    self.NewTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.NewTableV registerNib:[UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil] forCellReuseIdentifier:@"tCell"];
    [self.scrollV addSubview:self.NewTableV];
}

#pragma mark ----- tableView协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sortType == YES ? self.HotArr.count : self.NewArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityModel *model = [[CommunityModel alloc]init];
    if (self.sortType == YES) {
        model = self.HotArr[indexPath.row];
    } else if (self.sortType == NO) {
        model = self.NewArr[indexPath.row];
    }
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityDetailViewController *CDVC = [[CommunityDetailViewController alloc]init];
    CommunityModel *model = [[CommunityModel alloc]init];
    if (self.sortType == YES) {
        model = self.HotArr[indexPath.row];
        CDVC.url = model.contentid;
        [self.navigationController pushViewController:CDVC animated:YES];
    } else if (self.sortType == NO) {
        model = self.NewArr[indexPath.row];
        CDVC.url = model.contentid;
        [self.navigationController pushViewController:CDVC animated:YES];
    }
}

#pragma mark ----- 数据请求 -----
-(void)requestDataWithSort:(NSString *)sort Start:(NSInteger)start{
    self.parDic = [@{@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"client":@"1",@"sort":sort,@"limit":[NSString stringWithFormat:@"%ld", self.limitIndex * 10],@"version":@"3.0.2",@"start":[NSString stringWithFormat:@"%ld",start],@"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P0"}mutableCopy];
    [RequestManager requestWithUrlString:kTalkUrl parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",dic);

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
        
        NSArray *array = [CommunityModel modelConfigureWithJsonDic:dic];
        for (CommunityModel *model in array)
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
