//
//  CommunityTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/7/5.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CommunityTableViewCell.h"

@implementation CommunityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(CommunityModel *)model{
    self.titleL.text = model.title;
    self.timeL.text = model.addtime_f;
    self.contentL.text = model.content;
    self.commentL.text = [NSString stringWithFormat:@"%d",[model.comment intValue]];
    if (model.coverimg.length == 0) {
        self.imageV.frame = CGRectMake(0, 0, 0, 0);
        self.contentL.frame = CGRectMake(18, 70, 315, 69);
    } else {
      [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
    }
}

@end
