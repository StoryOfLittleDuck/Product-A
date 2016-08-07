//
//  LoginViewController.h
//  Product-A
//
//  Created by 林建 on 16/7/1.
//  Copyright © 2016年 林建. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^block11)(NSString *);
@interface LoginViewController : UIViewController
@property (nonatomic, copy)void(^loginSuccess)(NSString *);
@property (nonatomic, copy)block11 block11;
@end
