//
//  WTKOrderVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/10.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderVC.h"
#import "WTKOrderViewModel.h"
#import "WTKOrderTableView.h"
#import "WTKOrderMenuView.h"

#define MENU_TAG 1546

@interface WTKOrderVC ()

@property(nonatomic,strong)WTKOrderViewModel    *viewModel;

@property(nonatomic,strong)WTKOrderTableView    *tableView;

@property(nonatomic,strong)UIButton             *rightBtn;

@property(nonatomic,strong)WTKOrderMenuView     *menuView;

@end

@implementation WTKOrderVC
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel.menuClickSignal sendNext:@(self.viewModel.orderType)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
    [self resetNavi];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    
    RAC(self.tableView,dataArray)       = RACObserve(self.viewModel, array);
    self.tableView.viewModel            = self.viewModel;
    self.tableView.mj_header            = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.tableView];
    }];
    
    RAC(self.menuView,clickSignal)      = RACObserve(self.viewModel, menuClickSignal);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPop) name:@"wtk_cancelPop" object:nil];
}

- (void)initView
{
    [self.view addSubview:self.tableView];

}
- (void)cancelPop
{
    [self resetNavi];
}

- (void)resetNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backbutton_icon3"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];

}
- (void)right{
    if([self.view viewWithTag:MENU_TAG])
    {
        [self.menuView dismiss];
    }
    else
    {
        [self.view addSubview:self.menuView];
        [self.menuView beginAnimation];
    }
    
}
- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (WTKOrderTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[WTKOrderTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"wdiandian"] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"wdiandian"] forState:UIControlStateSelected];
        _rightBtn.frame = CGRectMake(0, 0, 23, 18);
    }
    return _rightBtn;
}
- (WTKOrderMenuView *)menuView
{
    if (!_menuView)
    {
        _menuView = [[WTKOrderMenuView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight) withData:@[@"全部订单",@"待付款",@"配送中",@"已配送",@"已完成"]];
        _menuView.tag = MENU_TAG;
    }
    return _menuView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
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
