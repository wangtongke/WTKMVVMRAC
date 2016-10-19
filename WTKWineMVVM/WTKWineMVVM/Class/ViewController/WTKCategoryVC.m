//
//  WTKCategoryVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCategoryVC.h"
#import "WTKCategoryViewModel.h"
#import "WTKCategoryRightTableView.h"
#import "WTKCategoryLeftTableViewCell.h"
@interface WTKCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKCategoryViewModel         *viewModel;

@property(nonatomic,strong)WTKCategoryRightTableView    *rightTableView;

@property(nonatomic,strong)UITableView                  *leftTableView;

@property(nonatomic,strong)NSMutableArray               *leftDataArray;

@property(nonatomic,strong)NSMutableDictionary          *dataDic;

@property(nonatomic,strong)UIButton                     *rightBtn;

@end

@implementation WTKCategoryVC
@dynamic viewModel;
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
    [self.viewModel.refreshCommand execute:@[self.leftTableView,self.rightTableView]];
//    RAC(self,dataDic)                   = RACObserve(self.viewModel, dataDic);
    RAC(self,leftDataArray)             = RACObserve(self.viewModel, leftArray);
    RAC(_rightTableView,sectionArray)   = RACObserve(self.viewModel, leftArray);
    RAC(_rightTableView,dataDic)        = RACObserve(self.viewModel, dataDic);
    self.rightTableView.mj_header       = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:@[self.leftTableView,self.rightTableView]];
    }];
    [self.viewModel.rightCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSIndexPath *indexPath = x;
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }];
//    需要传值，所以不这样写
//    RAC(self.rightBtn,rac_command)      = RACObserve(self.viewModel, selectedCommand);
    
    [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.selectedCommand execute:@[self.leftTableView,self.rightTableView]];
    }];
}

- (void)initView
{
    [self.view addSubview:self.rightTableView];
    [self.view addSubview:self.leftTableView];
    self.leftTableView.dataSource       = self;
    self.leftTableView.delegate         = self;
    self.leftTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.leftTableView.rowHeight        = 45;
    [self.leftTableView registerNib:[UINib nibWithNibName:@"WTKCategoryLeftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}
- (void)resetNavi
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:THEME_COLOR size:CGSizeMake(kWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.leftClickCommand execute:@[self.rightTableView,indexPath]];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL isFirst = YES;
    WTKCategoryLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.w_label.text = self.leftDataArray[indexPath.row];
    if(isFirst)
    {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    isFirst = NO;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftDataArray.count;
}


#pragma mark - lazyLoad
- (WTKCategoryRightTableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[WTKCategoryRightTableView alloc]initWithFrame:CGRectMake(75, 0, kWidth - 75, kHeight - 49) style:UITableViewStylePlain];
        _rightTableView.viewModel = self.viewModel;
    }
    return _rightTableView;
}
- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 75, kHeight - 64 - 49) style:UITableViewStylePlain];
        _leftTableView.backgroundColor  = [UIColor clearColor];
    }
    return _leftTableView;
}
- (NSMutableArray *)leftDataArray
{
    if (!_leftDataArray)
    {
        _leftDataArray = [NSMutableArray array];
    }
    return _leftDataArray;
}

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic)
    {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"w_shaixuan"] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(0, 0, 15, 15);
    }
    return _rightBtn;
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
