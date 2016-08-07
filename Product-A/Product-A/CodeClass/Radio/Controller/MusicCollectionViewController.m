//
//  MusicCollectionViewController.m
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicCollectionViewController.h"
#import "MusicCPViewController.h"
#import "MusicDListTableViewCell.h"
#import "DeleteModel.h"
BOOL click = YES;
BOOL All = YES;
@interface MusicCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *deleteB;
@property (nonatomic, strong)UIView *editV;
@property (nonatomic, strong)UIButton *checkB;
@property (nonatomic, strong)UIButton *removeB;
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSArray *Arr;
@property (nonatomic, strong)NSMutableArray *modelArr;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)MusicDownloadTable *table;
@property (nonatomic, assign)NSInteger index;
@end

@implementation MusicCollectionViewController
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return  _array;
}

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSArray *)Arr{
    if (!_Arr) {
        _Arr = [NSArray array];
        NSLog(@"%@",_Arr);
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
    UIView *vertical1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 20, 1, KNaviH)];
    vertical1.backgroundColor = PKCOLOR(100, 100,100);
    [self.view addSubview:vertical1];
    UIView *horizontal = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + KNaviH-1, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    [self.view addSubview:horizontal];
    [self.view addSubview:self.button];
    [self.view addSubview:self.deleteB];
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.editV];
    [self.editV addSubview:self.checkB];
    [self.editV addSubview:self.removeB];
    self.index = 999;
    // Do any additional setup after loading the view.
}

#pragma mark ----- 创建已下载歌曲界面 -----
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight -64-60-10) style:(UITableViewStylePlain)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [_tableV registerNib:[UINib nibWithNibName:@"MusicDListTableViewCell" bundle:nil] forCellReuseIdentifier:@"mListCell"];
    }
    return _tableV;
}

#pragma mark ----- tableView协议方法 -----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeleteModel *model = self.modelArr[indexPath.row];
    MusicDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mListCell" forIndexPath:indexPath];
    [cell cellConfigureWithModel:model];
    [self.array addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (click == NO) {
        NSInteger cc = indexPath.row;
        DeleteModel *model = self.modelArr[cc];
        if (model.isS == NO) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cc inSection:0];
            [self.tableV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cc inSection:0];
            [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
        }
        model.isS = !model.isS;
        int count = 0;
        for (DeleteModel *model in self.modelArr) {
            if (model.isS == YES) {
                count++;
            }
        }
        
        if (count == self.Arr.count) {
            All = YES;
            [self checkA];
        }         
    } else {
    MusicCPViewController *MCPVC = [[MusicCPViewController alloc]init];
    [MyPlayerManager defaultManader].Dindex = indexPath.row;
    MCPVC.index = indexPath.row;
    if (self.index == indexPath.row){
        
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.Arr];
        MCPVC.Arr = arr;
        [MyPlayerManager defaultManader].Dmusic = arr;
        [self.navigationController pushViewController:MCPVC animated:YES];
        
    }
    }
    self.index = indexPath.row;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger cc = indexPath.row;
    DeleteModel *model = self.modelArr[cc];
    model.isS = NO;
    [self.checkB setTitle:@"全选" forState:UIControlStateNormal];
    
}

#pragma mark ----- 删除方法 -----
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1|2;
}

#pragma mark ----- 创建编辑界面 -----
-(UIView *)editV{
    if (!_editV) {
        _editV = [[UIView alloc]init];
        _editV.backgroundColor = [UIColor lightGrayColor];
    }
    return _editV;
}

-(UIButton *)checkB{
    if (!_checkB) {
        _checkB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkB setTitle:@"全选" forState:UIControlStateNormal];
        [_checkB setTintColor:[UIColor whiteColor]];
        [_checkB addTarget:self action:@selector(checkA) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkB;
}

-(UIButton *)removeB{
    if (!_removeB) {
        _removeB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeB setTitle:@"删除" forState:UIControlStateNormal];
        [_removeB setTintColor:[UIColor whiteColor]];
        [_removeB addTarget:self action:@selector(removeA) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeB;
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

#pragma mark ----- 删除按钮 -----
-(UIButton *)deleteB{
    if (!_deleteB) {
        _deleteB = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteB.frame = CGRectMake(kScreenWidth - 40,20, KNaviH, KNaviH);
        [_deleteB setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        [_deleteB addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteB;
}

-(void)deleteAction{
    if (click == YES) {
        [self.tableV setEditing:YES animated:YES];
    [_deleteB setImage:[UIImage imageNamed:@"垃圾桶.png"] forState:UIControlStateNormal];
        self.editV.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
        self.checkB.frame = CGRectMake(0, 10, kScreenWidth/2, 30);
        self.removeB.frame = CGRectMake(kScreenWidth/2, 10, kScreenWidth/2, 30);
        click = NO;
        All = YES;
         [self.checkB setTitle:@"全选" forState:UIControlStateNormal];
    } else {
        [self.tableV setEditing:NO  animated:YES];
    [_deleteB setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        click = YES;
        self.editV.frame = CGRectMake(0, 0, 0,0);
        self.removeB.frame = CGRectMake(0, 0, 0, 0);
        self.checkB.frame = CGRectMake(0, 0, 0, 0);
    }
}

-(void)checkA{
    if (All == YES) {
       self.tableV.allowsMultipleSelectionDuringEditing= NO;
        [self.checkB setTitle:@"取消全选" forState:UIControlStateNormal];
        All = NO;
        for (int i = 0; i < self.Arr.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            DeleteModel *model = self.modelArr[i];
            model.isS = YES;
        }
    } else {
        [self.checkB setTitle:@"全选" forState:UIControlStateNormal];
        All = YES;
        for (int i = 0; i < self.Arr.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
            DeleteModel *model = self.modelArr[i];
            model.isS = NO;
        }
    }
}

-(void)removeA{
    
    for (NSInteger i = self.Arr.count - 1; i >= 0; i--)
    {
        DeleteModel *model = self.modelArr[i];
        if (model.isS == YES) {
            [self.modelArr removeObjectAtIndex:i];
            [self.table deleteDatefortitle:model.title];
        }
    }
    click = YES;
    [self deleteAction];
    [self viewWillAppear:YES];
}

-(MusicDownloadTable *)table{
    if (!_table) {
        _table = [[MusicDownloadTable alloc]init];
    }
    return _table;
}

-(void)viewWillAppear:(BOOL)animated{
    self.Arr = [self.table selectAll];
    self.modelArr = [DeleteModel modelConfigureWithArray:self.Arr];
    [self.tableV reloadData];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
