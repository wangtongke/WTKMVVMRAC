//
//  WTKMapVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMapVC.h"
#import "WTKMapViewModel.h"

@interface WTKMapVC ()

@property(nonatomic,strong)WTKMapViewModel *viewModel;

@end

@implementation WTKMapVC
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
