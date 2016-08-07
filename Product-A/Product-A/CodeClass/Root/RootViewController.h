//
//  RootViewController.h
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Music)(BOOL);
@interface RootViewController : UIViewController
@property (nonatomic, strong)MusicModel *model;
@property (nonatomic, strong)NSString *nameStr;
@property (nonatomic, strong)NSString *imageStr;
@property (nonatomic, copy)Music music;
@property (nonatomic, assign)BOOL isPlayer;
@property (nonatomic, assign)BOOL isLogin;
@property (nonatomic, assign)BOOL isSearch;//用来判断 是否处于搜索状态 YES为搜索状态 NO为正常状态
//@property (nonatomic, copy)playBlock pBlock;
@end
