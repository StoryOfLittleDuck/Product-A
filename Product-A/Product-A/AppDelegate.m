//
//  AppDelegate.m
//  Product-A
//
//  Created by 林建 on 16/6/24.
//  Copyright © 2016年 林建. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    StartViewController *sVC = [[StartViewController alloc]init];
    self.window.rootViewController = sVC;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.window addSubview:view];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"//appKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4c2169b3f8b88c62"
                                       appSecret:@"bfa71b2251df9aa41e2df2f26f4eb3bf"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bgInfo:) name:@"backPlay" object:nil];
    // 后台播放音频
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 让后台可以处理多媒体的事件
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // Override point for customization after application launch.
    return YES;
}


- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    NSLog(@"11");
//    [[MyPlayerManager defaultManader] changeMusicWith: [MyPlayerManager defaultManader].index];
//    [[MyPlayerManager defaultManader] nextMusic:ListPlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backReload" object:nil];
    
    //检测到摇动
    
}

#pragma mark --- 摇一摇切歌
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"111");
    
    //    [self reloadViewWithIndex:[MyPlayerManager defaultManader].index];
}


// 后台可以处理多媒体的事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //    NSLog(@"%ld", event.subtype);
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            //点击播放按钮或者耳机线控中间那个按钮
            [[MyPlayerManager defaultManader] play];
            break;
        case UIEventSubtypeRemoteControlPause:
            //点击暂停按钮
            [[MyPlayerManager defaultManader] pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            //点击下一曲按钮或者耳机中间按钮两下
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backNext" object:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            //点击上一曲按钮或者耳机中间按钮三下
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backAbove" object:nil];
            break;
            
        default:
            break;
    }
}

- (void)bgInfo:(NSNotification *)noti {
        CGFloat total = [[MyPlayerManager defaultManader] totalTime];
        CGFloat current = [[MyPlayerManager defaultManader] currentTime];
    
    MusicModel *model = noti.object;
    NSLog(@"%@",model.coverimg);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    //设置歌曲题目
    [dict setObject:model.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [dict setObject:[NSString stringWithFormat:@"%ld",[model.musicVisit integerValue]] forKey:MPMediaItemPropertyArtist];
    //设置显示的图片
//    if (model.isDownload ==YES) {
    
        UIImageView *imageV = [[UIImageView alloc]init];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg] completed:nil];
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:imageV.image] forKey:MPMediaItemPropertyArtwork];
        
//    }
    
    //    //设置歌曲时长
        [dict setObject:[NSNumber numberWithDouble:total] forKey:MPMediaItemPropertyPlaybackDuration];
    ////    //设置已经播放时长
        [dict setObject:[NSNumber numberWithDouble:current] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    NSLog(@"%ld",[MyPlayerManager defaultManader].index);
    //更新字典
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
