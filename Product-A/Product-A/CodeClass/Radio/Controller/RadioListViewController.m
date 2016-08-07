//
//  RadioListViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RadioListViewController.h"
#import "MusicPlayerViewController.h"
#import "RadioDetailModel.h"
#import "MusicTableViewCell.h"
#import "MusicModel.h"
@interface RadioListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIView *headerV;
@property (nonatomic, strong)UIView *middleV;
@property (nonatomic, strong)UILabel *titiel;
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSMutableArray *MLArr;
@property (nonatomic, strong)NSMutableDictionary *titleDic;
@property (nonatomic, strong)NSMutableDictionary *parDic;
@property (nonatomic, assign)NSInteger index;
@end

@implementation RadioListViewController

-(NSMutableArray *)MLArr{
    if (!_MLArr) {
        _MLArr = [NSMutableArray array];
    }
    return _MLArr;
}

-(NSMutableDictionary *)titleDic{
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
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
    [self button];
    [self titiel];
    
    [self requestData];
    self.index = 999;
    self.index1 = 999;
    // Do any additional setup after loading the view.
}

-(UILabel *)titiel{
    if (!_titiel) {
        self.titiel = [[UILabel alloc]initWithFrame:CGRectMake(45, 20, 120, 40)];
        self.titiel.text = self.strTitle;
        [self.view addSubview: self.titiel];
    }
    return _titiel;
}

#pragma mark ----- 大标题视图 -----
-(UIView *)headerV{
    if (!_headerV) {
        _headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth,180)];
        _headerV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppIcon60x60@3x.png"]];
        RadioDetailModel *model = [[RadioDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:self.titleDic];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
        [self.headerV addSubview:imageV];
        [self.view addSubview:self.headerV];
    }
    return _headerV;
}

#pragma mark ----- 中间视图 -----
-(UIView *)middleV{
    if (!_middleV) {
        _middleV = [[UIView alloc]initWithFrame:CGRectMake(0, 240, kScreenWidth, 100)];
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 50, 50)];
        NSDictionary *dic1 = self.titleDic[@"userinfo"];
        RadioDetailModel *model = [[RadioDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:self.titleDic];
        NSString *icon = dic1[@"icon"];
        //头像
        [imagev sd_setImageWithURL:[NSURL URLWithString:icon] completed:nil];
        imagev.layer.masksToBounds = YES;
        imagev.layer.cornerRadius = 25;
        [self.middleV addSubview:imagev];
        //名字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(90, 18, 150, 30)];
        label.text = dic1[@"uname"];
        label.font = [UIFont fontWithName:@"Helvetica" size:18];
        label.textColor =[UIColor lightGrayColor];
        [self.middleV addSubview:label];
        //签名
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 350, 30)];
        label1.text = model.desc;
        label1.font = [UIFont fontWithName:@"Helvetica" size:19];
        label1.textColor =[UIColor grayColor];
        [self.middleV addSubview:label1];
        //浏览次数
        UIImageView *imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 18, 20, 20)];
        imageV1.image = [UIImage imageNamed:@"WiFi.png"];
        [self.middleV addSubview:imageV1];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 18, 60, 20)];
        label2.text = [NSString stringWithFormat:@"%d",[model.musicvisitnum intValue]];
        label2.font = [UIFont fontWithName:@"Helvetica" size:15];
        label2.textColor =[UIColor lightGrayColor];
        [self.middleV addSubview:label2];
        [self.view addSubview:self.middleV];
    }
    return _middleV;
}

#pragma mark ----- 创建tableView -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 340, kScreenWidth, kScreenHeight - 340)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.view addSubview:self.tableV];
        [self.tableV registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MusicCell"];
    }
    return _tableV;
}

#pragma mark ----- tableView协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MLArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel *model = self.MLArr[indexPath.row];
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicPlayerViewController *MPVC = [[MusicPlayerViewController alloc]init];
    MPVC.index1 = ^(NSInteger index){
        self.index1 = index;
    };
    MPVC.index = indexPath.row;
    for (MusicModel *model in self.MLArr) {
        [MPVC.Arr addObject:model.musicUrl];
    }
    MPVC.array = self.MLArr;
    MPVC.index = indexPath.row;
    MusicModel *model = self.MLArr[indexPath.row];
//    [MyPlayerManager defaultManader].musicName = model.title;
    MPVC.model = self.MLArr[indexPath.row];
    if ([[MyPlayerManager defaultManader].musicName isEqualToString:model.title] && [MyPlayerManager defaultManader].isZT == YES && [MyPlayerManager defaultManader].first != 1) {
         MPVC.model.isSelect = YES;
        [self.navigationController pushViewController:MPVC animated:YES];
    } else {
    if ([MyPlayerManager defaultManader].index == indexPath.row  && self.index != 999)
    {
        MPVC.model.isSelect = YES;
        [self.navigationController pushViewController:MPVC animated:YES];
        
    }
    else
    {
            [MyPlayerManager defaultManader].musicLists = self.MLArr;
        
            [self.navigationController pushViewController:MPVC animated:YES];
    }
    }
    self.index = indexPath.row;
    [MyPlayerManager defaultManader].first = 2;
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

-(void)back{
    [MyPlayerManager defaultManader].isZT = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- 数据请求 -----
-(void)requestData{
     [self.parDic setValue:self.strPar forKey:@"radioid"];
    [RequestManager requestWithUrlString:kRadioDetailURL parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        self.titleDic = [RadioDetailModel ModelConfigureWithJsonDic:dic];
        self.MLArr = [MusicModel modelConfigureWithJsonDic:dic];
        [self headerV];
        [self middleV];
        [self tableV];
        [self.tableV reloadData];
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
    MusicTableViewCell *cell = sender;
    NSIndexPath *index = [self.tableV indexPathForCell:cell];
    [MyPlayerManager defaultManader].musicLists = self.MLArr;
    [MyPlayerManager defaultManader].index = index.row;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
