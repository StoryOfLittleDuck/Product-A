//
//  RightViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "RightViewController.h"
#import "RootViewController.h"
@interface RightViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    [self.view addSubview:self.titleLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(40, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical];
    
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    [self.view addSubview:horizontal];
    [self.view addGestureRecognizer:self.tap];
    [self.view addGestureRecognizer:self.pan];
    
    //初始化边界平移手势
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panWithFinger:)];
    //设置边界为左边界
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
    // Do any additional setup after loading the view.
}

-(void)panWithFinger:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.navigationController.view.superview];
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.origin.x = point.x;
    [self constrainNewFrame:&newFrame];
    
    self.navigationController.view.frame = newFrame;
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self changeFrameWithType:MoveTypeRight];
    }
}

-(void)panShowRootVC:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.navigationController.view.superview];
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.origin.x = point.x;
    [self constrainNewFrame:&newFrame];
    
    self.navigationController.view.frame = newFrame;
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self changeFrameWithType:MoveTypeLeft];
    }
}

//约束坐标
-(void)constrainNewFrame:(CGRect *)newFrame{
    if (newFrame->origin.x >= kScreenWidth - kMoveDistance) {
        newFrame->origin.x = kScreenWidth - kMoveDistance;
    } else if (newFrame->origin.x <= 0){
        [self changeFrameWithType:MoveTypeRight];
    }
}

-(void)changeFrameWithType:(MoveType)type{
    //获取当前的frame
    CGRect newFrame = self.navigationController.view.frame;
    if (type == MoveTypeLeft) {
        newFrame.origin.x = 0;
        self.button.userInteractionEnabled = YES;
        self.tap.enabled = NO;
        self.pan.enabled = NO;
    } else if (type == MoveTypeRight){
    //改变它的的坐标原点
        self.tap.enabled = YES;
        self.pan.enabled = YES;
        self.button.userInteractionEnabled = NO;
        newFrame.origin.x = kScreenWidth - kMoveDistance;
    }
    [UIView animateWithDuration:0.5 animations:^{
        //给个动画0.5s
        self.navigationController.view.frame = newFrame;
    }];
}

#pragma mark ----- 属性 -----
-(UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20 + 10, 20, 20)];
        [_button setTitle:@"三" forState:UIControlStateNormal];
        [_button setTitleColor:PKCOLOR(25, 25, 25) forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(showRootVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideRootVC:)];
    }
    return _tap;
}

-(UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panShowRootVC:)];
        _pan.enabled = NO;
    }
    return _pan;
}

#pragma mark ----- 抽屉 -----
-(void)showRootVC:(UIButton *)sender{
    [self changeFrameWithType:MoveTypeRight];
}


-(void)hideRootVC:(UITapGestureRecognizer *)sender{
    [self changeFrameWithType:MoveTypeLeft];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 10 + 20, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = PKCOLOR(25, 25, 25);
    }
    return _titleLabel;
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
