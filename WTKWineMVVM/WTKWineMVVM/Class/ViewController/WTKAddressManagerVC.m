//
//  WTKAddressManagerVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/25.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAddressManagerVC.h"
#import "WTKAddressManagerViewModel.h"
#import "WTKAddressTableViewCell.h"
@interface WTKAddressManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKAddressManagerViewModel   *viewModel;

@property(nonatomic,strong)UITableView                  *tableView;

@property(nonatomic,strong)NSMutableArray<WTKAddress *> *dataArray;

///新建地址
@property(nonatomic,strong)UIButton                     *addAddress;



@end

@implementation WTKAddressManagerVC
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [WTKDataManager saveUserData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];

}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    RAC(self.addAddress,rac_command)    = RACObserve(self.viewModel, addAddressCommand);
    [self.viewModel.deleteAddress.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight        = 135;
    [self.tableView registerNib:[UINib nibWithNibName:@"WTKAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    UIView *bottomView              = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 60, kWidth, 60)];
    bottomView.backgroundColor      = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.addAddress.frame           = CGRectMake(30, 10, kWidth - 60, 35);
    [bottomView addSubview:self.addAddress];
    _addAddress.layer.cornerRadius  = 5;
    _addAddress.layer.masksToBounds = YES;
    _addAddress.layer.borderColor   = THEME_COLOR.CGColor;
    _addAddress.layer.borderWidth   = 0.4;
    _addAddress.titleLabel.font     = [UIFont wtkNormalFont:20];
    [_addAddress setTitle:@"+ 新建地址" forState:UIControlStateNormal];
    [_addAddress setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    
    
}
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.cellClickCommand execute:self.dataArray[indexPath.row]];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKAddressTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WTKAddress *address             = self.dataArray[indexPath.row];
    [cell updateAddress:address];
    [cell.subject subscribeNext:^(id x) {
        if ([x[@"code"] integerValue] == 100)
        {
//            编辑
            [self.viewModel.editAddress execute:x[@"address"]];
        }
        else
        {
//            删除
            [self.viewModel.deleteAddress execute:x[@"address"]];
        }
    }];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSMutableArray<WTKAddress *> *)dataArray
{
    return CURRENT_USER.address;
}
- (UIButton *)addAddress
{
    if (!_addAddress)
    {
        _addAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addAddress;
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
