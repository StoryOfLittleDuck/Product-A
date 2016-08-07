//
//  MusicCPViewController.h
//  Product-A
//
//  Created by 林建 on 16/7/2.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteModel.h"
@interface MusicCPViewController : UIViewController
@property (nonatomic, strong)NSMutableArray *Arr;
@property (nonatomic, strong)MusicModel *model;
@property (nonatomic, strong)DeleteModel *model1;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)BOOL isEdit;
@end
