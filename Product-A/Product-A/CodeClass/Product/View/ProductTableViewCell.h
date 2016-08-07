//
//  ProductTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/7/3.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PModel.h"
@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *buyB;

-(void)cellConfigureWithModel:(PModel *)model;
@end
