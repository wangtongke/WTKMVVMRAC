//
//  WTKOrderDetailVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderDetailVC.h"
#import "WTKOrderDetailViewModel.h"
#import "WTKOrderModel.h"
#import "WTKOrderDetailModel.h"
#import "WTKOrderDetailTableViewCell.h"
#import "WTKOrderStateTableView.h"

#define cellID0 @"CELL1"
#define cellID1 @"CELL2"
#define cellID2 @"CELL3"


#define GO_PAY 100
#define GO_CUIDAN 101
#define GO_COMFIRM 102



@interface WTKOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKOrderDetailViewModel  *viewModel;

@property(nonatomic,strong)UITableView              *tableView;

@property(nonatomic,strong)UISegmentedControl       *segment;

@property(nonatomic,strong)WTKOrderStateTableView   *statusTable;

@property(nonatomic,strong)UIView                   *bottomView;

@property(nonatomic,strong)UIButton                 *doneBtn;

@end

@implementation WTKOrderDetailVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
//    订单状态数据
    [self.viewModel.requestStatusCommand execute:self.statusTable];
    @weakify(self);
    [[self.segment rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        UISegmentedControl *seg         = x;
        if (seg.selectedSegmentIndex == 0)
        {
            self.tableView.hidden       = NO;
            self.statusTable.hidden     = YES;
        }
        else
        {
            self.tableView.hidden       = YES;
            self.statusTable.hidden     = NO;
        }
    }];
    
    RAC(self.statusTable,dataArray)     = RACObserve(self.viewModel, statusArray);
    
    self.statusTable.mj_header          = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestStatusCommand execute:self.statusTable];
    }];

}

- (void)initView
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.statusTable];
    self.statusTable.hidden         = YES;
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView   = self.segment;
    [self.view addSubview:self.bottomView];
    
}
- (void)bottomBtnClick:(UIButton *)btn
{
    
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WTKOrderDetailTableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID0];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKOrderDetailTableViewCell" owner:nil options:nil];
            cell = array[0];
        }
        [cell updateCell1:self.viewModel.order];
        
    }
    else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKOrderDetailTableViewCell" owner:nil options:nil];
            cell = array[1];
        }
        [cell updateCell2:self.viewModel.order.ordergoods[indexPath.row]];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKOrderDetailTableViewCell" owner:nil options:nil];
            cell = array[2];
        }
        [cell updateCell3:self.viewModel.order];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 225;
    }
    else if (indexPath.section == 1)
    {
        return 75;
    }
    else
    {
        return 162;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return section == 1 ? self.viewModel.order.ordergoods.count : 1;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView      = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (UISegmentedControl *)segment
{
    if (!_segment)
    {
        _segment        = [[UISegmentedControl alloc]initWithItems:@[@"订单详情",@"订单状态"]];
        _segment.frame  = CGRectMake(0, 0, 100, 30);
        NSDictionary *selectDic = @{NSForegroundColorAttributeName :WTKCOLOR(70, 70, 70, 1),NSFontAttributeName:[UIFont wtkNormalFont:14]};
        NSDictionary *normalDic = @{NSForegroundColorAttributeName :WTKCOLOR(140, 140, 140, 1),NSFontAttributeName:[UIFont wtkNormalFont:14]};
        [_segment setTitleTextAttributes:selectDic forState:UIControlStateSelected];
        [_segment setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        _segment.selectedSegmentIndex = 0;
        _segment.tintColor  = THEME_COLOR;
    }
    return _segment;
}
- (WTKOrderStateTableView *)statusTable
{
    if (!_statusTable)
    {
        _statusTable = [[WTKOrderStateTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight) style:UITableViewStylePlain];
        _statusTable.order = self.viewModel.order;
    }
    return _statusTable;
}
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 49, kWidth, 49)];
        _bottomView.backgroundColor = WTKCOLOR(30, 30, 30, 0.8);
        
        UILabel *moneyLabel     = [[UILabel alloc] initWithFrame:(CGRectMake(15,10, kWidth/2-20, 29))];
        moneyLabel.text         = [NSString stringWithFormat:@"¥%.2f",self.viewModel.order.paycost];
        moneyLabel.textColor    = [UIColor whiteColor];
        moneyLabel.font         = [UIFont systemFontOfSize:17];
        moneyLabel.minimumScaleFactor = 11.f;
        moneyLabel.adjustsFontSizeToFitWidth = YES;
        [_bottomView addSubview:moneyLabel];
        
        [_bottomView addSubview:self.doneBtn];
        
        
    }
    return _bottomView;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn)
    {
        _doneBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame          = CGRectMake(kWidth - 150, 0, 150, 49);
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneBtn.backgroundColor = THEME_COLOR;
        _doneBtn.titleLabel.font = [UIFont wtkNormalFont:19];
        [_doneBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self setDoneBtnTitle:_doneBtn];
        
    }
    return _doneBtn;
}

/**重设bottomBtn*/
- (void)setDoneBtnTitle:(UIButton *)btn
{
    if ([self.viewModel.order.workflow_state isEqualToString:@"generation"])
    {
        btn.hidden              = NO;
        btn.tag                 = GO_PAY;
        [btn setTitle:@"去付款" forState:UIControlStateNormal];
    }
    else if ([self.viewModel.order.workflow_state isEqualToString:@"cancelled"])
    {
        btn.hidden              = YES;
    }
    else if ([self.viewModel.order.workflow_state isEqualToString:@"paid"])
    {
        btn.hidden              = NO;
        btn.tag                 = GO_CUIDAN;
        [btn setTitle:@"去催单" forState:UIControlStateNormal];
    }
    else if ([self.viewModel.order.workflow_state isEqualToString:@"distribution"])
    {
        btn.hidden              = NO;
        btn.tag                 = GO_COMFIRM;
        [btn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    else if ([self.viewModel.order.workflow_state isEqualToString:@"completed"])
    {
        btn.hidden              = YES;
    }
    else if ([self.viewModel.order.workflow_state isEqualToString:@"receive"])
    {
        btn.hidden              = NO;
        btn.tag                 = GO_COMFIRM;
        [btn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
