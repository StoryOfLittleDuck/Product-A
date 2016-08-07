//
//  MusicView.h
//  Product-A
//
//  Created by 林建 on 16/6/29.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *descL;
@property (strong, nonatomic) IBOutlet UILabel *collectL;
@property (strong, nonatomic) IBOutlet UILabel *messageL;
@property (strong, nonatomic) IBOutlet UISlider *playSilder;
@property (weak, nonatomic) IBOutlet UIButton *DownloadB;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *backV;
@property (nonatomic, assign)NSInteger aaa;
@property (nonatomic, strong)UILabel *label;
@end
