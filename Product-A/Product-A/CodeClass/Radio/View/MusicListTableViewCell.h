//
//  MusicListTableViewCell.h
//  Product-A
//
//  Created by 林建 on 16/6/30.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *downloadB;
@property (weak, nonatomic) IBOutlet UILabel *kuaiL;

-(void)cellWithModel:(MusicModel *)model;
@end
