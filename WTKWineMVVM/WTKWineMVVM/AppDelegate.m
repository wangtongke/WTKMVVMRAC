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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",NSHomeDirectory());
    [self changeRootViewController];
//    NSArray *arr   = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeHead" ofType:nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    设置键盘
    IQKeyboardManager *manager          = [IQKeyboardManager sharedManager];
    manager.enable                      = YES;
    manager.shouldResignOnTouchOutside  = YES;
    manager.enableAutoToolbar           = NO;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    

    [self readUserData];

    
    return YES;
}

/**读取购物车*/
- (void)readUserData
{
    [WTKDataManager readUserData];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shoppingCar.plist"];
//    NSError *error;
//    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
//    if (!error)
//    {
//        WTKShoppingManager *manager = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [WTKShoppingManager manager].goodsDic = manager.goodsDic;
//    }
}


- (void)changeRootViewController
{
    UIWindow *window                    = [[UIApplication sharedApplication].delegate window];
    WTKTabBarController *tabbarC        = [[WTKTabBarController alloc]init];
    tabbarC.tabBar.tintColor            = THEME_COLOR;
    window.rootViewController           = tabbarC;
    
//    WTKHomeVC *homeVC           = [[WTKHomeVC alloc]initWithViewModel:[[WTKHomeViewModel alloc]initWithService:nil params:@{@"title":@"首页"}]];
//    WTKNavigationController *nav1 = [self setChildVC:homeVC title:@"首页" imageName:@"homeNormal" withSelectedName:@"homeHight"];
//    
//    WTKCategoryVC *cateVC       = [[WTKCategoryVC alloc]initWithViewModel:[[WTKCategoryViewModel alloc]initWithService:nil params:@{@"title":@"分类"}]];
//    WTKNavigationController *nav2 =  [self setChildVC:cateVC title:@"分类" imageName:@"categoryNormal" withSelectedName:@"categoryHight"];
//    
//    WTKFoundVC *foundVC         = [[WTKFoundVC alloc]initWithViewModel:[[WTKFoundViewModel alloc]initWithService:nil params:@{@"title":@"发现"}]];
//    WTKNavigationController *nav3 =   [self setChildVC:foundVC title:@"发现" imageName:@"foundNormal" withSelectedName:@"foundHight"];
//    
//    WTKShoppingCarVC *shopVC    = [[WTKShoppingCarVC alloc]initWithViewModel:[[WTKShoppingCarViewModel alloc]initWithService:nil params:@{@"title":@"购物车"}]];
//    WTKNavigationController *nav4 =  [self setChildVC:shopVC title:@"购物车" imageName:@"carNormal" withSelectedName:@"carHight"];
//    
//    WTKMeVC *meVC               = [[WTKMeVC alloc]initWithViewModel:[[WTKMeViewModel alloc]initWithService:nil params:@{@"title":@"我的"}]];
//    WTKNavigationController *nav5 =  [self setChildVC:meVC title:@"我的" imageName:@"meNoraml" withSelectedName:@"meHight"];
//    
//    tabbarC.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
}
- (WTKNavigationController *)setChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imgName withSelectedName:(NSString *)selectedName
{
    vc.title                = title;
    vc.tabBarItem.image     = [UIImage imageNamed:imgName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedName];
    
    vc.tabBarController.tabBar.tintColor   = THEME_COLOR;
    
    NSDictionary *dic       = @{NSForegroundColorAttributeName:BLACK_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]};
    [vc.tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *selectDic = @{NSForegroundColorAttributeName:THEME_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]};
    [vc.tabBarItem setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    
    WTKNavigationController *nav = [[WTKNavigationController alloc]initWithRootViewController:vc];
    return nav;
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
