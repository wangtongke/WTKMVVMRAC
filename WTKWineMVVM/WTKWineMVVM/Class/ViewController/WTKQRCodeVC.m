//
//  WTKQRCodeVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/16.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKQRCodeVC.h"
#import "WTKQRCodeViewModel.h"
@interface WTKQRCodeVC ()

@property(nonatomic,strong)WTKQRCodeViewModel   *viewModel;

@end

@implementation WTKQRCodeVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
}
- (void)bindViewModel
{
    [super bindViewModel];
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
