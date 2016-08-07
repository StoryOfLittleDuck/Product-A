//
//  ProductTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/7/3.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(PModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
    self.titleL.text = model.title;
}

@end
