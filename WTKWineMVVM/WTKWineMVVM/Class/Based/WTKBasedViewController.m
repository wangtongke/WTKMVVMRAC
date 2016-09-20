//
//  WTKBasedViewController.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewController.h"

@interface WTKBasedViewController ()
@property(nonatomic,strong,readwrite)WTKBasedViewModel *viewModel;
@end

@implementation WTKBasedViewController

- (instancetype)initWithViewModel:(WTKBasedViewModel *)viewModel
{
    if (self == [super init])
    {
        self.viewModel = viewModel;
//        [self bindViewModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = WTKCOLOR(240, 240, 240, 1);
    [self resetNaviWithTitle:@""];
    self.viewModel.naviImpl             = [[WTKViewModelNavigationImpl alloc]initWithNavigationController:self.navigationController];
}

- (void)bindViewModel
{
    RAC(self.navigationItem,title)     = RACObserve(self.viewModel, title);
}


- (void)resetNaviWithTitle:(NSString *)title
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = btn;
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
