//
//  MusicDListTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/7/1.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicDListTableViewCell.h"

@implementation MusicDListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)cellConfigureWithModel:(DeleteModel *)model{
    self.titleL.text = model.title;
    self.nameL.text = model.name;
}
@end
