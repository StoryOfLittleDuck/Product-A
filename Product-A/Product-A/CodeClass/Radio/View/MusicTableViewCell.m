//
//  MusicTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/28.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(MusicModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
    self.musicVisitL.text = model.musicVisit;
    self.titleL.text = model.title;
}
@end
