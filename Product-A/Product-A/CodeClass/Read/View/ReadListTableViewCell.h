//
//  ReadListTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadDetailModel.h"
@interface ReadListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

-(void)cellConfigureWithModel:(ReadDetailModel *)model;
@end
