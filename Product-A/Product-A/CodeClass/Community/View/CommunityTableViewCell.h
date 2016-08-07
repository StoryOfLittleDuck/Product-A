//
//  CommunityTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/7/5.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"
@interface CommunityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *commentL;

-(void)cellConfigureWithModel:(CommunityModel *)model;
@end
