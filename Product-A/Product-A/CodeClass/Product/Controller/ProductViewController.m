//
//  ProductViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "PModel.h"
@interface ProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSMutableArray *Arr;
@property (nonatomic ,strong)NSMutableDictionary *parDic;
@end

@implementation ProductViewController

-(NSMutableArray *)Arr{
    if (!_Arr) {
        _Arr = [NSMutableArray array];
    }
    return _Arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableV];
    
    self.limitIndex = 1;
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.Arr removeAllObjects];
        self.start = 0;
        [self requestDataWithStar:self.start];
    }];
    self.tableV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.start = self.limitIndex * 10;
        self.limitIndex += 1;
        [self requestDataWithStar:self.start];
    }];
    [self.tableV.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建tableView -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.tableV registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"pCell"];
    }
    return _tableV;
}

#pragma mark ----- 协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PModel *model = self.Arr[indexPath.row];
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    cell.buyB.layer.masksToBounds = YES;
    cell.buyB.layer.cornerRadius = 10;
    cell.buyB.layer.borderColor = [[UIColor blackColor]CGColor];
    cell.buyB.layer.borderWidth = 0.5f;
    cell.buyB.tag = indexPath.row;
    [cell.buyB addTarget:self action:@selector(GoBuy:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailViewController *PDVC = [[ProductDetailViewController alloc]init];
    PModel *model = [[PModel alloc]init];
        model = self.Arr[indexPath.row];
        PDVC.url = model.contentid;
    [self.navigationController pushViewController:PDVC animated:YES];
}

-(void)GoBuy:(UIButton *)button{
  PModel *model = self.Arr[button.tag];
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.buyurl]];
}

#pragma mark ----- 数据请求 -----
-(void)requestDataWithStar:(NSInteger)start{
    self.parDic = [@{@"start":[NSString stringWithFormat:@"%ld",start],@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"limit":[NSString stringWithFormat:@"%ld", self.limitIndex * 10],@"auth":@"",@"version":@"3.0.2"}mutableCopy];
    [RequestManager requestWithUrlString:kUrlProduct parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",dic);
        NSDictionary *Dic = dic[@"data"];
        NSString *s = [NSString stringWithFormat:@"%@",Dic[@"total"]];
        if ([s isEqualToString:@"0"])
        {
            NSLog(@"没有更多数据");
            [self.tableV.mj_footer endRefreshing];
            return;
        }
        
        if (start == 0)
        {
            // 把数组里面的元素全部清空掉
            [self.Arr removeAllObjects];
        }
        
        NSArray *array = [PModel modelConfigureWithJsonDic:dic];
        for (PModel *model in array)
        {
                [self.Arr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV reloadData];
            [self.tableV.mj_header endRefreshing];
            [self.tableV.mj_footer endRefreshing];
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
