//
//  ReplyTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/7/4.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(ReplyModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.icon] completed:nil];
    self.nameL.text = model.uname;
    self.timeL.text = model.addtime_f;
    self.contentL.text = model.content;
}
@end
