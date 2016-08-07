//
//  StartViewController.m
//  Product-A
//
//  Created by 林建 on 16/7/7.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "StartViewController.h"
#import "RootViewController.h"
@interface StartViewController ()
@property (nonatomic, strong)UIImageView *imageV;
@end

@implementation StartViewController
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
        _imageV.image = [UIImage imageNamed:@"LaunchImage-700-568h@2x.png"];
        _imageV.center = self.view.center;
    }
    return _imageV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageV];
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你的手机支持3Dtouch" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"很遗憾，不支持" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    RootViewController *rootVC = [[RootViewController alloc]init];
    [UIView animateWithDuration:2 animations:^{
        self.imageV.frame = CGRectMake(0, 0, kScreenWidth * 1.5, kScreenHeight*1.5);
        self.imageV.center = self.view.center;
    } completion:^(BOOL finished) {
        [self presentViewController:rootVC animated:NO completion:nil];
    }];
    // Do any additional setup after loading the view.
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
