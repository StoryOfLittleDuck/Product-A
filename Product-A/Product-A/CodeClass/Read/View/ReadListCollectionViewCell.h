//
//  ReadListCollectionViewCell.h
//  Product-A
//
//  Created by 林建 on 16/6/25.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadListModel.h"
@interface ReadListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UILabel *nameL;

-(void)cellConfigureWithModel:(ReadListModel *)model;
@end
