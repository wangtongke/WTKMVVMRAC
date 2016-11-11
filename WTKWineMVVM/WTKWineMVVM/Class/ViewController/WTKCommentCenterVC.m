//
//  WTKCommentCenterVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentCenterVC.h"
#import "WTKCommentCenterViewModel.h"
#import "WTKCommentCenterTableViewCell.h"
@interface WTKCommentCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKCommentCenterViewModel *viewModel;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray   *dataArray;

@end

@implementation WTKCommentCenterVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindViewModel];
    [self resetNavi];
    
}
- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    //监听取消返回事件
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"wtk_cancelPop" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self resetNavi];
    }];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.rowHeight        = 120;
    [self.tableView registerClass:[WTKCommentCenterTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)resetNavi
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
}

#pragma mark tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
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
