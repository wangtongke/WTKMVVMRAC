//
//  WTKMeVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMeVC.h"

@interface WTKMeVC ()

@end

@implementation WTKMeVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/product/slideshow" withParamater:@{@"id":@"56c45924c2fb4e2050000022"}] subscribeNext:^(id x) {
//        NSLog(@"111111%@",x);
//    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = [UIColor redColor];

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
