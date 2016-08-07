//
//  CCollectionViewCell.m
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "CCollectionViewCell.h"

@implementation CCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.imageV];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50,20)];
        self.label.text = @"精选";
        self.label.backgroundColor = [UIColor greenColor];
        self.label.textColor = [UIColor whiteColor];
        [self.contentView addSubview: self.label];
    }
    return self;
}

-(void)cellConfigureWithModel:(CModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
}
@end
