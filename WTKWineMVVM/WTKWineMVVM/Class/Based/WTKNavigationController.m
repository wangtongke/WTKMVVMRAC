//
//  WTKNavigationController.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKNavigationController.h"

@interface WTKNavigationController ()

@end

@implementation WTKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetNavi];
}
/**
 导航栏
 */
- (void)resetNavi
{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:THEME_COLOR size:CGSizeMake(kWidth, 64)] forBarMetrics:UIBarMetricsDefault];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
