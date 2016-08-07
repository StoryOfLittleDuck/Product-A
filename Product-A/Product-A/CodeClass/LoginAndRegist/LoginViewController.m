//
//  LoginViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/1.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
#import "RegistViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *registB;
@end

@implementation LoginViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    UIView *vertical1 = [[UIView alloc]initWithFrame:CGRectMake( kScreenWidth-40, 20, 1, KNaviH)];
    vertical1.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical1];
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    [self.view addSubview:horizontal];
    [self.view addSubview:self.button];
    [self.view addSubview:self.registB];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----- 返回按钮 -----
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,20, KNaviH, KNaviH);
        [_button setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark ----- 注册按钮 -----
-(UIButton *)registB{
    if (!_registB) {
        _registB = [UIButton buttonWithType:UIButtonTypeCustom];
        _registB.frame = CGRectMake(kScreenWidth-KNaviH,20, KNaviH, KNaviH);
        [_registB setImage:[UIImage imageNamed:@"注册.png"] forState:UIControlStateNormal];
        [_registB addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registB;
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)registAction{
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

//登录
- (IBAction)loginB:(id)sender {
    NSDictionary *params = @{@"email":_emailTF.text,@"passwd":_passwordTF.text};
    [RequestManager requestWithUrlString:kLoginUrl parDic:params requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        if ([dic[@"result"] integerValue] == 0) {
//            NSLog(@"%@",dic[@"data"][@"msg"]);
            UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"警告" message: dic[@"data"][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *aA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [aC addAction:aA];
            [self presentViewController:aC animated:YES completion:nil];
        } else {
            [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
            [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
            [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
            [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
            if (self.loginSuccess) {
                self.loginSuccess(dic[@"data"][@"icon"]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.block11 != nil) {
                    self.block11(dic[@"data"][@"uname"]);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
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
