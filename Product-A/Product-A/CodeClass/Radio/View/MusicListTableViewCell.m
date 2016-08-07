//
//  MusicListTableViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithModel:(MusicModel *)model{
    NSDictionary *dic = model.playInfo;
     NSDictionary *Dic = dic[@"authorinfo"];
    self.titleL.text = model.title;
    self.nameL.text = [NSString stringWithFormat:@"by: %@",Dic[@"uname"]];
    if ([[MyPlayerManager defaultManader].musicName isEqualToString:model.title]) {
        self.kuaiL.backgroundColor = [UIColor greenColor];
    } else {
        self.kuaiL.backgroundColor = [UIColor clearColor];
    }
}

@end
