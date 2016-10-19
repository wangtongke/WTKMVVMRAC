//
//  WTKSetUpVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSetUpVC.h"
#import "WTKSetupViewModel.h"
#import "WTKSetupTableViewCell.h"

@interface WTKSetUpVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKSetupViewModel    *viewModel;

@property(nonatomic,strong)UITableView          *tableView;

@property(nonatomic,strong)NSArray              *array;



/**退出按钮*/
@property(nonatomic,strong)UIButton             *exitBtn;

@end

@implementation WTKSetUpVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPop) name:@"wtk_cancelPop" object:nil];
}

- (void)initView
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WTKSetupTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight    = 44;
    
    UIView *headerView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    self.tableView.tableHeaderView = headerView;
    

}

- (void)resetNavi
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
}

- (void)cancelPop
{
    [self resetNavi];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.cellClickSubject sendNext:@[@(indexPath.row),tableView]];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *array  = @[[WTKTool getCacheSize],@"",[WTKTool getVersion],@"",@""];
    [cell updateTitle:self.array[indexPath.row] subTitle:array[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CURRENT_USER.isLogin ? 5 : 4;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (CURRENT_USER.isLogin)
    {
        UIView *footView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 65)];
        self.exitBtn.frame      = CGRectMake(30, 30, kWidth - 60, 35);
        [footView addSubview:self.exitBtn];
        @weakify(self);
        [[self.exitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel.exitSubject sendNext:tableView];
        }];
        return footView;
    }
    else
    {
        UIView *view            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.01)];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (CURRENT_USER.isLogin)
    {
        return 65;
    }
    return 0.01;
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (NSArray *)array
{
    if (!_array)
    {
        _array = @[@"清除缓存",@"功能",@"关于",@"帮助中心",@"密码管理"];
    }
    return _array;
}


- (UIButton *)exitBtn
{
    if (!_exitBtn)
    {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _exitBtn.layer.cornerRadius     = 5;
        _exitBtn.layer.masksToBounds    = YES;
        _exitBtn.layer.borderColor      = THEME_COLOR.CGColor;
        _exitBtn.layer.borderWidth      = 0.3;
        _exitBtn.backgroundColor        = WTKCOLOR(253, 253, 253, 1);
    }
    return _exitBtn;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了");
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
