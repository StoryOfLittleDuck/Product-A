//
//  ReadListTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadListTableViewCell.h"

@implementation ReadListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(ReadDetailModel *)model{
    self.titleLabel.text = model.title;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
    self.contentLabel.text = model.content;
}

@end
