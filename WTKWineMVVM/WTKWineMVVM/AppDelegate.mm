//
//  AppDelegate.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "AppDelegate.h"
#import "WTKTabBarController.h"
#import "WTKNavigationController.h"
#import "WTKHomeVC.h"
#import "WTKCategoryVC.h"
#import "WTKFoundVC.h"
#import "WTKShoppingCarVC.h"
#import "WTKMeVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <UMMobClick/MobClick.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",NSHomeDirectory());
//    NSArray *arr   = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeHead" ofType:nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    设置键盘
    IQKeyboardManager *manager          = [IQKeyboardManager sharedManager];
    manager.enable                      = YES;
    manager.shouldResignOnTouchOutside  = YES;
    manager.enableAutoToolbar           = NO;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    

    [self readUserData];

    [self registShareSDK];
    
    [self registUM];
    
    BMKMapManager *mapManager           = [[BMKMapManager alloc]init];
    if ([mapManager start:@"MoboTBCXuQbImL0wfRSCtyHAjk9j6prp" generalDelegate:nil])
    {
        NSLog(@"百度地图startSuccess");
//        开始定位
        [[WTKMapManager manager] startUserLocation];
    }
    
    [self changeRootViewController];
    return YES;
}

/**读取购物车*/
- (void)readUserData
{
    [WTKDataManager readUserData];

}

#pragma mark - UM and shareSDK
/** UM*/
- (void)registUM
{
    UMConfigInstance.appKey = @"585a1bfc82b6353d33001888";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setCrashReportEnabled:YES];
}

/** shareSDK*/
- (void)registShareSDK
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
        
        [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
        [ShareSDK registerApp:@"f67e4aa87334" activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
            switch (platformType)
            {
                case SSDKPlatformTypeWechat:
                    [ShareSDKConnector connectWeChat:[WXApi class]];
                    break;
                case SSDKPlatformTypeQQ:
                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                    break;
                case SSDKPlatformTypeSinaWeibo:
                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                    break;
                    
                default:
                    break;
            }
        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
            switch (platformType)
            {
                    
                case SSDKPlatformTypeWechat:
                    [appInfo SSDKSetupWeChatByAppId:@"wx99edba10fa9ee81d"
                                          appSecret:@"083faf098658c1633756cd3dbef84a72"];
                    break;
                case SSDKPlatformTypeQQ:
                    [appInfo SSDKSetupQQByAppId:@"1105742566"
                                         appKey:@"Jzj1vRwc8GNe4m36"
                                       authType:SSDKAuthTypeBoth];
                    break;
                    
                default:
                    break;
            }
        }];
        
    });
}

- (void)changeRootViewController
{
    UIWindow *window                    = [[UIApplication sharedApplication].delegate window];
    WTKTabBarController *tabbarC        = [[WTKTabBarController alloc]init];
    tabbarC.tabBar.tintColor            = THEME_COLOR;
    window.rootViewController           = tabbarC;
    

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [NSKeyedArchiver archiveRootObject:[WTKShoppingManager manager] toFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shoppingCar.plist"]];
//    NSLog(@"%@",[WTKShoppingManager manager].goodsDic);
#pragma mark - 退出保存用户数据
//    退出保存用户数据
    [WTKDataManager saveUserData];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [WTKDataManager saveUserData];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



@end
