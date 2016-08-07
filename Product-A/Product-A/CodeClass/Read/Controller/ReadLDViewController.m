//
//  ReadLDViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/3.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadLDViewController.h"
#import "ReplyViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface ReadLDViewController ()
@property (nonatomic, strong)UIButton *fontB;
@property (nonatomic, strong)UIButton *collectionB;
@property (nonatomic, strong)UIButton *speakB;
@property (nonatomic, strong)UILabel *speakL;
@property (nonatomic, strong)UILabel *likeL;
@property (nonatomic, strong)UIButton *moreB;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIWebView *wView;
@property (nonatomic, strong)UISlider *textSlider;
@property (nonatomic, strong)NSDictionary *parDic;
@property (nonatomic, strong)UIImageView *errorImage;
@end

@implementation ReadLDViewController
-(NSDictionary *)parDic{
    if (!_parDic) {
        _parDic = [NSDictionary dictionary];
    }
    return _parDic;
}

#pragma mark ----- 创建字体滑块图 -----
-(UISlider *)textSlider{
    if (!_textSlider) {
        _textSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textSlider.minimumValue = 10;
        _textSlider.maximumValue = 30;
        _textSlider.value = 20;
        [_textSlider addTarget:self action:@selector(textAction) forControlEvents:UIControlEventValueChanged];
    }
    return _textSlider;
}

-(void)textAction{
    NSString *botySise = [[NSString alloc]initWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%fpx'",self.textSlider.value];
    NSString *titleSise = [[NSString alloc]initWithFormat:@"document.getElementsByTagName('h1')[0].style.fontSize='%fpx'",self.textSlider.value + 7];
    [self.wView stringByEvaluatingJavaScriptFromString:botySise];
    [self.wView stringByEvaluatingJavaScriptFromString:titleSise];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isText = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH -1, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    //字体按钮
    _fontB = [UIButton buttonWithType:UIButtonTypeCustom];
    _fontB.frame = CGRectMake(kScreenWidth /2 -60, 25, 30, 30);
    [_fontB setImage:[UIImage imageNamed:@"ic_font_box_white_24px.png"] forState:UIControlStateNormal];
    [_fontB addTarget:self action:@selector(fontA) forControlEvents:UIControlEventTouchUpInside];
    //评论按钮
    _speakB = [UIButton buttonWithType:UIButtonTypeCustom];
    _speakB.frame = CGRectMake(kScreenWidth /2 , 25, 30, 30);
    [_speakB setTitle:@"11" forState:UIControlStateNormal];
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
    [self.view addSubview:self.likeL];
    [self.view addSubview:self.speakL];
    [self.view addSubview:self.moreB];
    [self.view addSubview:self.collectionB];
    [self.view addSubview:self.speakB];
    [self.view addSubview:self.fontB];
    [self.view addSubview:self.button];
    [self.view addSubview:self.wView];
    [self.view addSubview:self.textSlider];
    [self.view addSubview:horizontal];
    [self requestData];
    [self.view addSubview:self.errorImage];
    // Do any additional setup after loading the view.
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

-(void)fontA{
    if (self.isText == YES) {
        self.textSlider.frame = CGRectMake(20, kScreenHeight - 20, kScreenWidth - 40, 20);
        self.isText = NO;
    } else {
        self.isText = YES;
        self.textSlider.frame = CGRectMake(0, 0, 0, 0);
    }
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

#pragma mark ----- 数据请求 -----
-(void)requestData{
    NSLog(@"%@",self.url);
    self.parDic = [@{@"contentid":self.url}mutableCopy];
    [RequestManager requestWithUrlString:kdetailUrl parDic:self.parDic requestType:RequestPOST finish:^(NSData *data) {
        self.errorImage.image = [UIImage imageNamed:@""];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *Dic = dic[@"data"];
//        NSLog(@"%@",Dic);
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

-(UIImageView *)errorImage{
    if (!_errorImage) {
        _errorImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60)];
    }
    return _errorImage;
}

-(UIWebView *)wView{
    if (!_wView) {
        _wView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60,kScreenWidth,kScreenHeight - 64 -60 -10)];
    }
    return _wView;
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
