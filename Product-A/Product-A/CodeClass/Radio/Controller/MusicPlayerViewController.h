//
//  MusicPlayerViewController.h
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
typedef void(^Blockindex)(NSInteger);
@interface MusicPlayerViewController : UIViewController
@property (nonatomic, copy)Blockindex index1;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)MusicModel *model;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableArray *Arr;
@property (nonatomic, strong)NSString *UrlStr;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSInteger aaa;
@end
