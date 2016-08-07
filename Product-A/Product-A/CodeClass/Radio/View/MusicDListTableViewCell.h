//
//  MusicDListTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/7/1.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteModel.h"
@interface MusicDListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *downloadV;

-(void)cellConfigureWithModel:(DeleteModel *)model;
@end
