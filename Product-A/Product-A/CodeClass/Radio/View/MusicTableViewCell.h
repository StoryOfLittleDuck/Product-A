//
//  MusicTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface MusicTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UIImageView *playV;
@property (strong, nonatomic) IBOutlet UILabel *musicVisitL;
@property (strong, nonatomic) IBOutlet UIImageView *playv;

-(void)cellConfigureWithModel:(MusicModel *)model;
@end
