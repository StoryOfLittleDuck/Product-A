//
//  RegistViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/1.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSInteger _gender;//性别
}
@property (nonatomic, strong)UIImagePickerController *pickVC;
@property (nonatomic, strong)UIImage *uploadImage;
@property (nonatomic, strong)UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *man;
@property (weak, nonatomic) IBOutlet UIButton *woman;
@property (nonatomic, strong)UIButton *login;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _uploadImage = [UIImage imageNamed:@"搜索 (1).png"];
    self.view.backgroundColor = [UIColor whiteColor];
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
    _man.layer.masksToBounds = YES;
    _man.layer.cornerRadius = 16;
    _woman.layer.masksToBounds = YES;
    _woman.layer.cornerRadius = 16;
    _headImageV.layer.masksToBounds = YES;
    _headImageV.layer.cornerRadius = 70;
    
    [self.view addSubview:horizontal];
    [self.view addSubview:self.button];
    [self.view addSubview:self.login];
    [self addGesture];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----- 添加手势 -----
-(void)addGesture{
    self.headImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action)];
    [self.headImageV addGestureRecognizer:tap];
}

-(void)action{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.pickVC = [[UIImagePickerController alloc]init];
        self.pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.pickVC.allowsEditing = YES;
        self.pickVC.delegate = self;
        [self presentViewController:self.pickVC animated:YES completion:^{
            NSLog(@"移除控件");
        }];
    } else {
        NSLog(@"你没有相册！！");
    }
}

#pragma mark ----- UIImagePickerControllerDelegate -----
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    UIImagePickerControllerEditedImage   裁剪之后的
//    UIImagePickerControllerOriginalImage 原始的
    _uploadImage = info[UIImagePickerControllerEditedImage];
    _headImageV.image = _uploadImage;
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",info);
    }];
}

#pragma mark ----- 返回按钮 -----
-(UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(kScreenWidth - KNaviH,20, KNaviH, KNaviH);
        [_button setImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark ----- 登录按钮 -----
-(UIButton *)login{
    if (!_login) {
        _login = [UIButton buttonWithType:UIButtonTypeCustom];
        _login.frame = CGRectMake(0,20, KNaviH, KNaviH);
        [_login setImage:[UIImage imageNamed:@"登录.png"] forState:UIControlStateNormal];
        [_login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login;
}

-(void)loginAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)manB:(id)sender {
    _gender = 0;
    _man.backgroundColor = [UIColor redColor];
    _woman.backgroundColor = [UIColor clearColor];
}

- (IBAction)womanB:(id)sender {
    _gender = 1;
    _man.backgroundColor = [UIColor clearColor];
    _woman.backgroundColor = [UIColor redColor];
}

- (IBAction)fininsh:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    //如果请求出现content-type相关错误，用一些两种方案解决
    //应该适用于一切出现content-type
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kRegistUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //uploadImage
        [formData appendPartWithFileData:UIImagePNGRepresentation(_uploadImage) name:@"iconfile" fileName:@"uploadheadimage.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[_emailTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
        [formData appendPartWithFormData:[_passwordTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"passwd"];
        [formData appendPartWithFormData:[_nameTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"uname"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%ld",(long)_gender] dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount /uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        NSDictionary *data = dic[@"data"];
        NSString *a = [NSString stringWithFormat:@"%ld",[dic[@"result"] integerValue]];
        if ([a isEqualToString: @"0"] ) {
//            NSLog(@"%@",data[@"msg"]);
            UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"警告" message: data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *aA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [aC addAction:aA];
            [self presentViewController:aC animated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    } ];
//    NSDictionary *params = @{@"email":_emailTF.text,@"gender":[NSNumber numberWithInteger:_gender],@"passwd":_passwordTF.text,@"uname":[_nameTF.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
//    [RequestManager requestWithUrlString:kRegistUrl parDic:params requestType:RequestPOST finish:^(NSData *data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
//        if ([dic[@"result"] integerValue] == 0) {
//            NSLog(@"%@",dic[@"data"][@"msg"]);
//        } else {
//            [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
//            [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
//            [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
//            [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } error:^(NSError *error) {
//        NSLog(@"error == %@",error);
//    }];
    
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
