//
//  RightViewController.h
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveType){
    MoveTypeLeft,
    MoveTypeRight
};

@interface RightViewController : UIViewController
@property (nonatomic, strong)UILabel *titleLabel;
//hide or show
-(void)changeFrameWithType:(MoveType)type;
@end
