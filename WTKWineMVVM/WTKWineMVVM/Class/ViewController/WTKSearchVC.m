//
//  WTKSearchVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSearchVC.h"
#import "WTKSearchViewModel.h"
#import "MSSAutoresizeLabelFlow.h"
#import "WTKSearchResultView.h"
#define HISTORY @"historySearch"

@interface WTKSearchVC ()<UISearchBarDelegate>

@property(nonatomic,strong)WTKSearchViewModel       *viewModel;

@property(nonatomic,strong)UIScrollView             *bgView;

@property(nonatomic,strong)UISearchBar              *searchBar;

@property(nonatomic,strong)UITableView              *tableView;

@property(nonatomic,strong)MSSAutoresizeLabelFlow   *hotSearchView;

@property(nonatomic,strong)MSSAutoresizeLabelFlow   *history;

@property(nonatomic,strong)NSMutableArray           *historyArray;
///删除
@property(nonatomic,strong)UIButton                 *deleteBtn;
///搜索结果
@property(nonatomic,strong)WTKSearchResultView      *resultView;
@end

@implementation WTKSearchVC
@dynamic viewModel;
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.99)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.viewModel.vc = self;
    [self bindViewModel];
    [self resetNavi];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [self.viewModel.searchCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSArray *a = x;
        if (a.count <= 0)
        {
            [self.history reloadAllWithTitles:self.historyArray];
            return;
        }
        NSArray *array = [WTKGood mj_objectArrayWithKeyValuesArray:x context:nil];
        self.resultView.dataArray = array;
        [self.view addSubview:self.resultView];
        [self.resultView w_reloadData];
    }];
    
    RAC(self.deleteBtn,rac_command) = RACObserve(self.viewModel, deleteHistory);
    
    [self.viewModel.deleteHistory.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
       [self.history reloadAllWithTitles:self.historyArray];
    }];
}
///导航栏
- (void)resetNavi
{
    self.searchBar.barStyle         = UISearchBarStyleDefault;
    //    self.searchBar.tintColor        = WTKCOLOR(70, 70, 70, 1);
    self.searchBar.delegate         = self;
    self.searchBar.placeholder      = @"搜索";
    _searchBar.layer.cornerRadius   = 5;
    _searchBar.layer.masksToBounds  = YES;
    _searchBar.layer.borderColor    = WTKCOLOR(200, 200, 200, 1).CGColor;
    _searchBar.layer.borderWidth    = 0.5;
    UIView *bgView                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth - 60, 44 * ZOOM_SCALL)];
    self.navigationItem.titleView   = bgView;
    [bgView addSubview:self.searchBar];
    
}
- (void)initView{
    self.view.backgroundColor       = WTKCOLOR(253, 253, 253, 1);
    [self.view addSubview:self.bgView];
    UILabel *hotLabel               = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 * ZOOM_SCALL, kWidth, 46 * ZOOM_SCALL)];
    hotLabel.textColor              = WTKCOLOR(150, 150, 150, 1);
    hotLabel.font                   = [UIFont wtkNormalFont:16];
    hotLabel.text                   = @"  热门商品";
    [self.bgView addSubview:hotLabel];
    [self.bgView addSubview:self.hotSearchView];
    _hotSearchView.backgroundColor  = [UIColor clearColor];
    
    UILabel *historyLabel           = [[UILabel alloc]initWithFrame:CGRectMake(0, 210 * ZOOM_SCALL, kWidth, 40 * ZOOM_SCALL)];
    historyLabel.textColor          = WTKCOLOR(150, 150, 150, 1);
    historyLabel.font               = [UIFont wtkNormalFont:16];
    historyLabel.text               = @"  历史记录";
    [self.bgView addSubview:historyLabel];
    [self.bgView addSubview:self.history];
    _history.backgroundColor        = [UIColor clearColor];
    
    self.deleteBtn.frame            = CGRectMake(50, 400 * ZOOM_SCALL, kWidth - 100, 50);
    _deleteBtn.titleLabel.font      = [UIFont wtkNormalFont:17];
    _deleteBtn.backgroundColor      = WTKCOLOR(199, 199, 199, 1);
    _deleteBtn.layer.cornerRadius   = 6;
    _deleteBtn.layer.masksToBounds  = YES;
    _deleteBtn.layer.borderColor    = THEME_COLOR.CGColor;
    _deleteBtn.layer.borderWidth    = 0.3;
    [_deleteBtn setTitle:@"删除记录" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [self.bgView addSubview:self.deleteBtn];
}


#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.viewModel.searchCommand execute:searchBar.text];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.resultView removeFromSuperview];
    [self.history reloadAllWithTitles:self.historyArray];
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.resultView removeFromSuperview];
    [self.history reloadAllWithTitles:self.historyArray];
    [searchBar resignFirstResponder];
}

#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    return _tableView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(1, 8, kWidth - 62, 28)];
    }
    return _searchBar;
}
- (MSSAutoresizeLabelFlow *)hotSearchView
{
    if (!_hotSearchView)
    {
        @weakify(self);
        _hotSearchView = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 100 * ZOOM_SCALL, kWidth, 100 * ZOOM_SCALL) titles:@[@"茅台",@"汾酒",@"泸州",@"海之蓝",@"牛栏山",@"百威",@"费尔德城堡",@"剑南春",@"夜宴",@"农夫"] selectedHandler:^(NSUInteger index, NSString *title) {
            NSLog(@"%@",title);
            @strongify(self);
            [self.viewModel.searchCommand execute:title];
        }];
    }
    return _hotSearchView;
}

- (MSSAutoresizeLabelFlow *)history
{
    if (!_history)
    {
        @weakify(self);
        _history = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 250 * ZOOM_SCALL, kWidth, 150 * ZOOM_SCALL) titles:self.historyArray selectedHandler:^(NSUInteger index, NSString *title) {
            @strongify(self);
            [self.viewModel.searchCommand execute:title];
        }];
    }
    return _history;
}
- (NSMutableArray *)historyArray
{
    if (![USER_DEFAULTS valueForKey:HISTORY])
    {
        [USER_DEFAULTS setValue:@[].mutableCopy forKey:HISTORY];
    }
    _historyArray = [USER_DEFAULTS valueForKey:HISTORY];
    return _historyArray;
}
- (UIScrollView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _bgView.contentSize = CGSizeMake(kWidth, _bgView.frame.size.height * 1.001);
    }
    return _bgView;
}
- (UIButton *)deleteBtn
{
    if (!_deleteBtn)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleteBtn;
}
- (WTKSearchResultView *)resultView
{
    if (!_resultView)
    {
        _resultView = [[WTKSearchResultView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64)];
        _resultView.viewModel = self.viewModel;
    }
    return _resultView;
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
