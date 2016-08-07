//
//  CCollectionViewCell.h
//  Product-A
//
//  Created by 林建 on 16/6/27.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CModel.h"
@interface CCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *label;

-(void)cellConfigureWithModel:(CModel *)model;
@end
