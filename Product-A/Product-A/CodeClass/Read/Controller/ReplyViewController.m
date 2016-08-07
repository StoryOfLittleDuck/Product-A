//
//  ReplyViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/3.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReplyViewController.h"
#import "ReplyTableViewCell.h"
#import "ReplyModel.h"
@interface ReplyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSMutableArray *Arr;
@property (nonatomic, strong)NSDictionary *parDic;
@property (nonatomic, strong)UITextView *speakTV;
@property (nonatomic, strong)UITextField *speakTF;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *speakB;
@property (nonatomic, strong)UIButton *sendB;

@end

@implementation ReplyViewController
-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    _tableV = nil;
}

-(NSDictionary *)parDic{
    if (!_parDic) {
        _parDic = [NSDictionary dictionary];
    }
    return _parDic;
}

-(NSMutableArray *)Arr{
    if (!_Arr) {
        _Arr = [NSMutableArray array];
    }
    return _Arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //通知
    //键盘将要出来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH , kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    //更多按钮
    _speakB = [UIButton buttonWithType:UIButtonTypeCustom];
    _speakB.frame = CGRectMake(kScreenWidth /2 + 150, 25, 30, 30);
    [_speakB setImage:[UIImage imageNamed:@"评论 (1).png"] forState:UIControlStateNormal];
    [_speakB addTarget:self action:@selector(speakA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.speakB];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.speakTV];
    // Do any additional setup after loading the view.
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

#pragma mark ----- 数据请求 -----
-(void)requestDataWithStar:(NSInteger)start{
    self.parDic = [@{@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo",@"contentid":self.url,@"deviceid":@"6D4DD967-5EB2-40E2-A202-37E64F3BEA31",@"limit":[NSString stringWithFormat:@"%ld", self.limitIndex * 10],@"start":[NSString stringWithFormat:@"%ld",start],@"version":@"3.0.6"}mutableCopy];
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

#pragma mark ----- 创建tableView -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self.tableV registerNib:[UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"rCell"];
    }
    return _tableV;
}

#pragma mark ----- 协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyModel *model = self.Arr[indexPath.row];
    CGFloat f =[AdjustHeight adjustHeightBystring:model.content width:280 font:17];
    return  f+140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyModel *model = self.Arr[indexPath.row];
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    cell.imageV.layer.masksToBounds = YES;
    cell.imageV.layer.cornerRadius =40;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除
        ReplyModel *model = self.Arr[indexPath.row];
        if (model.isL) {
            // 删除数据
            [self.Arr removeObjectAtIndex:indexPath.row];
            // 删除cell
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self deleteComment:model];
        }
        
        [self.tableV reloadData];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.speakTV addSubview:self.speakTF];
    [self.speakTV addSubview:self.sendB];
    [self.speakTF resignFirstResponder];
}

#pragma mark ----- 创建评论框 -----
-(UITextView *)speakTV{
    if (!_speakTV) {
        _speakTV = [[UITextView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
        _speakTV.backgroundColor = PKCOLOR(180, 170, 190);
        _speakTV.returnKeyType = UIReturnKeySend;
    }
    return _speakTV;
}

-(UITextField *)speakTF{
    if (!_speakTF) {
        _speakTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, kScreenWidth-60, 34)];
        _speakTF.backgroundColor = [UIColor whiteColor];
        _speakTF.delegate = self;
    }
    return _speakTF;
}

-(UIButton *)sendB{
    if (!_sendB) {
        _sendB = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendB.frame = CGRectMake(kScreenWidth - 53, 4,  48, 32);
        [_sendB setTitle:@"发送" forState:UIControlStateNormal];
        [_sendB addTarget:self action:@selector(sendA) forControlEvents:UIControlEventTouchUpInside];
        [_sendB setTintColor:[UIColor whiteColor]];
        _sendB.backgroundColor = [UIColor greenColor];
        _sendB.layer.masksToBounds = YES;
        _sendB.layer.cornerRadius = 8;
    }
    return _sendB;
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

#pragma mark ----- 发送方法 -----
-(void)sendA{
[self uploadComment:self.speakTF.text];
}

#pragma mark ----- 评论方法 -----
-(void)speakA{
    [self.speakTF becomeFirstResponder];
}

#pragma mark ----- 键盘 -----
-(void)keyBoardShow:(NSNotification *)note{
//    UIKeyboardAnimationCurveUserInfoKey 动画时间
//    UIKeyboardFrameEndUserInfoKey 键盘出现后的位置
//    note.userInfo.[UIKeyboardFrameEndUserInfoKey]
    CGRect newRect = [note.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey  ] integerValue] animations:^{
        //只会走一次
        self.speakTV.transform = CGAffineTransformMakeTranslation(0, -newRect.size.height - self.speakTV.height);
    }];
}

-(void)keyBoardHidden:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue ] animations:^{
        self.speakTV.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.speakTV.text = @"";
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self uploadComment:textField.text];
        return NO;
    }
    return YES;
}

////触发上传方法
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        //上传
//        [self uploadComment:textView.text];
//        return NO;
//    }
//    return YES;
//}

#pragma mark ----- 提交评论 -----
-(void)uploadComment:(NSString *)comment{
//auth--用户信息   content--内容    contentid--文章
//    NSLog(@"%@",self.url);
    [RequestManager requestWithUrlString:kReplyAdd parDic:@{@"auth":[UserInfoManager getUserAuth],@"content":comment,@"contentid":self.url} requestType:RequestPOST finish:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV.mj_header beginRefreshing];
        });
    } error:^(NSError *error) {
        NSLog(@"error ==%@",error);
    }];
}

#pragma mark ----- 删除评论 -----
-(void)deleteComment:(ReplyModel *)model{
    //auth--用户信息   content--内容    contentid--文章
    [RequestManager requestWithUrlString:kReplyDelete parDic:@{@"auth":[UserInfoManager getUserAuth],@"contentid":self.url,@"commentid":model.contentid} requestType:RequestPOST finish:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV.mj_header beginRefreshing];
        });
    } error:^(NSError *error) {
        NSLog(@"error ==%@",error);
    }];
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
