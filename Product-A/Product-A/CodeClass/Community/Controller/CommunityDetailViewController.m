//
//  CommunityDetailViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/5.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "ReplyViewController.h"
#import "ReplyTableViewCell.h"
#import "ReplyModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface CommunityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *collectionB;
@property (nonatomic, strong)UIButton *speakB;
@property (nonatomic, strong)UIButton *moreB;
@property (nonatomic, strong)UILabel *speakL;
@property (nonatomic, strong)UILabel *likeL;
@property (nonatomic, strong)UIWebView *wView;
@property (nonatomic, strong)UIImageView *errorImage;
@property (nonatomic, strong)NSDictionary *parDic;

@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSMutableArray *Arr;
@property (nonatomic, strong)NSDictionary *parDic1;
@property (nonatomic, strong)UITextView *speakTV;
@property (nonatomic, assign)NSInteger count;
@end

@implementation CommunityDetailViewController
-(NSDictionary *)parDic{
    if (!_parDic) {
        _parDic = [NSDictionary dictionary];
    }
    return _parDic;
}

-(NSDictionary *)parDic1{
    if (!_parDic1) {
        _parDic1 = [NSDictionary dictionary];
    }
    return _parDic1;
}

-(NSMutableArray *)Arr{
    if (!_Arr) {
        _Arr = [NSMutableArray array];
    }
    return _Arr;
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
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH -1, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    //评论按钮
    _speakB = [UIButton buttonWithType:UIButtonTypeCustom];
    _speakB.frame = CGRectMake(kScreenWidth /2 -20, 25, 30, 30);
    [_speakB setImage:[UIImage imageNamed:@"评论.png"] forState:UIControlStateNormal];
    [_speakB addTarget:self action:@selector(speakA) forControlEvents:UIControlEventTouchUpInside];
    //收藏按钮
    _collectionB = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionB.frame = CGRectMake(kScreenWidth /2 + 70, 25, 30, 30);
    [_collectionB setImage:[UIImage imageNamed:@"收藏藏.png"] forState:UIControlStateNormal];
    [_collectionB addTarget:self action:@selector(collectionA) forControlEvents:UIControlEventTouchUpInside];
    //更多按钮
    _moreB = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreB.frame = CGRectMake(kScreenWidth /2 + 150, 25, 30, 30);
    [_moreB setImage:[UIImage imageNamed:@"navigationbar_more@2x.png"] forState:UIControlStateNormal];
    [_moreB addTarget:self action:@selector(moreA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.speakB];
    [self.view addSubview:self.moreB];
    [self.view addSubview:self.collectionB];
    [self.view addSubview:self.likeL];
    [self.view addSubview:self.speakL];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.errorImage];

    [self.view addSubview:self.wView];
    
//    self.tableV.tableHeaderView.backgroundColor = [UIColor clearColor];
    [self requestData];
    // Do any additional setup after loading the view.
}

#pragma mark ----- 数据请求 -----
-(void)requestData{
    self.parDic = [@{@"contentid":self.url}mutableCopy];
    [RequestManager requestWithUrlString:kdetailUrl parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        self.errorImage.image = [UIImage imageNamed:@""];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *Dic = dic[@"data"];
//                NSLog(@"%@",Dic);
        NSDictionary *list = Dic[@"counterList"];
        self.speakL.text = [NSString stringWithFormat:@"%d",[list[@"comment"] intValue]];
        self.likeL.text = [NSString stringWithFormat:@"%d",[list[@"like"] intValue]];
        NSString *html = Dic[@"html"];
        html = [NSString importStyleWithHtmlString:html];
        [self.wView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
        self.errorImage.image = [UIImage imageNamed:@"1636061550-4.jpg"];
    }];
}



#pragma mark ----- 数据请求 -----
-(void)requestDataWithStar:(NSInteger)start{
    self.parDic1 = [@{@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo",@"contentid":self.url,@"deviceid":@"6D4DD967-5EB2-40E2-A202-37E64F3BEA31",@"limit":[NSString stringWithFormat:@"%ld", self.limitIndex * 10],@"start":[NSString stringWithFormat:@"%ld",start],@"version":@"3.0.6"}mutableCopy];
    [RequestManager requestWithUrlString:kReply parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
        
        NSArray *array = [ReplyModel ModelConfigureWithJsonDic:dic];
        for (ReplyModel *model in array)
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刷新请求数据
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
}

-(UIImageView *)errorImage{
    if (!_errorImage) {
        _errorImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60)];
    }
    return _errorImage;
}

-(UIWebView *)wView{
    if (!_wView) {
        _wView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 1)];
        _wView.backgroundColor = [UIColor clearColor];
        _wView.delegate = self;
        _wView.scrollView.scrollEnabled = NO;
    }
    return _wView;
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGFloat height = [[self.wView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    NSLog(@"%f",height);
    self.wView.frame = CGRectMake(self.wView.frame.origin.x,self.wView.frame.origin.y, kScreenWidth, height);
    self.tableV.tableHeaderView = self.wView;
    [self.tableV reloadData];
}

#pragma mark ----- 创建tableView -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight  -60) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.tableV registerNib:[UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"rCell"];
    }
    return _tableV;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.wView;
//}

#pragma mark ----- 协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyModel *model = self.Arr[indexPath.row];
    CGFloat f =[AdjustHeight adjustHeightBystring:model.content width:280 font:17];
    return  f+130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyModel *model = self.Arr[indexPath.row];
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    cell.imageV.layer.masksToBounds = YES;
    cell.imageV.layer.cornerRadius =40;
    return cell;
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

-(UILabel *)speakL{
    if (!_speakL) {
        _speakL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth /2 + 15, 30, 55, 35)];
    }
    return _speakL;
}

-(UILabel *)likeL{
    if (!_likeL) {
        _likeL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth /2 + 110, 30, 45, 35)];
    }
    return _likeL;
}

-(void)speakA{
    ReplyViewController *RVC = [[ReplyViewController alloc]init];
    RVC.url = self.url;
    [self.navigationController pushViewController:RVC animated:YES];
}

-(void)collectionA{
    
}

-(void)moreA{
    //分享
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"1636061550-4.jpg"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }
    
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
