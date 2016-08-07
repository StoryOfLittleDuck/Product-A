//
//  DTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "DTableViewCell.h"

@implementation DTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithDModel:(DModel *)model{
    self.titleL.text = model.title;
    NSDictionary *dic = model.userinfo;
    self.nameL.text = [NSString stringWithFormat:@"by:%@",dic[@"uname"]];
    self.contentL.text = model.desc;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
}
@end
