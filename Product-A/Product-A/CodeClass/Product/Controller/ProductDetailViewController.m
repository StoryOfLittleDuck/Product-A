//
//  ProductDetailViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/4.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ReplyViewController.h"
@interface ProductDetailViewController ()
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)NSMutableDictionary *parDic;
@property (nonatomic, strong)UIButton *collectionB;
@property (nonatomic, strong)UIButton *speakB;
@property (nonatomic, strong)UIButton *moreB;
@property (nonatomic, strong)UILabel *speakL;
@property (nonatomic, strong)UILabel *likeL;
@property (nonatomic, strong)UIWebView *wView;
@end

@implementation ProductDetailViewController
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
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH -1, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    
    //评论按钮
    _speakB = [UIButton buttonWithType:UIButtonTypeCustom];
    _speakB.frame = CGRectMake(kScreenWidth /2 , 25, 30, 30);
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
    [self.view addSubview:self.wView];
    [self requestData];
    // Do any additional setup after loading the view.
}

#pragma mark ----- 数据请求 -----
#warning message ----- 有<httmel> ------
-(void)requestData{
//    NSLog(@"%@",self.url);
    self.parDic = [@{@"contentid":self.url,@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo"}mutableCopy];
    [RequestManager requestWithUrlString:kDetailProduct parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *Dic = dic[@"data"];
        NSDictionary *List = Dic[@"postsinfo"];
//        NSLog(@"%@",list);
        NSDictionary *list = List[@"counterList"];
        self.speakL.text = [NSString stringWithFormat:@"%d",[list[@"comment"] intValue]];
        self.likeL.text = [NSString stringWithFormat:@"%d",[list[@"like"] intValue]];
        NSString *html = List[@"html"];
        html = [NSString importStyleWithHtmlString:html];
        [self.wView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    } error:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}


-(UIWebView *)wView{
    if (!_wView) {
        _wView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60,kScreenWidth,kScreenHeight - 60)];
    }
    return _wView;
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
        _speakL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth /2 + 35, 25, 30, 30)];
    }
    return _speakL;
}

-(UILabel *)likeL{
    if (!_likeL) {
        _likeL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth /2 + 105, 25, 40, 30)];
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
