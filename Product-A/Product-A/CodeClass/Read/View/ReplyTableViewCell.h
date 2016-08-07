//
//  ReplyTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/7/4.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyModel.h"
@interface ReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

-(void)cellConfigureWithModel:(ReplyModel *)model;
@end
