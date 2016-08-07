//
//  ReadListCollectionViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/25.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "ReadListCollectionViewCell.h"
#define w self.frame.size.width
#define h self.frame.size.height
@implementation ReadListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        [self.contentView addSubview:self.imageV];
        self.nameL = [[UILabel alloc]init];
        self.nameL.textColor = [UIColor whiteColor];
        self.nameL.font = [UIFont fontWithName:@"Helvetica" size:21];
        [self.contentView addSubview:self.nameL];
        self.titleL = [[UILabel alloc]init];
        self.titleL.font = [UIFont fontWithName:@"Helvetica" size:10];
        self.titleL.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleL];
        
    }
    return self;
}

-(void)cellConfigureWithModel:(ReadListModel *)model{
    self.titleL.text = model.enname;
    self.nameL.text = model.name;
    self.nameL.frame = CGRectMake(0, h - 45, self.nameL.text.length *22, 60);
    self.titleL.frame = CGRectMake(self.nameL.text.length * 22, h-35, self.titleL.text.length * 18, 50);
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
}
@end
