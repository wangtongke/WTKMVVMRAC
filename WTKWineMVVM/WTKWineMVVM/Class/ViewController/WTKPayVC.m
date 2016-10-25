//
//  WTKPayVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/24.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPayVC.h"
#import "WTKPayViewModel.h"
#import "WTKOrderDetailTableViewCell.h"
@interface WTKPayVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKPayViewModel  *viewModel;

@property(nonatomic,strong)UITableView      *tableView;

///支付方式
@property(nonatomic,strong)NSArray          *payTypeArray;
///支付方式图片
@property(nonatomic,strong)NSArray          *payImageArray;
///费用名称
@property(nonatomic,strong)NSArray          *costName;

///费用
@property(nonatomic,strong)NSArray          *costArray;

///支付方式
@property(nonatomic,assign)NSInteger        payType;

@property(nonatomic,strong)UIView           *bottomView;
///价格
@property(nonatomic,strong)UILabel          *priceLabel;
///确认付款
@property(nonatomic,strong)UIButton         *payBtn;


@end

@implementation WTKPayVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.99)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.payType = 1;
    [self bindViewModel];
    [self initView];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [[self.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.payCommand execute:@(self.payType)];
    }];
    
//    payFinish
    [self.viewModel.payCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.payBtn];
    
    self.priceLabel.font            = [UIFont wtkNormalFont:16];
    self.priceLabel.textColor       = [UIColor whiteColor];
    self.priceLabel.text            = [NSString stringWithFormat:@"实付款 ：¥%.2f",self.viewModel.price];
    
    
    self.payBtn.titleLabel.font     = [UIFont wtkNormalFont:18];
    self.payBtn.backgroundColor     = THEME_COLOR;
    [self.payBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
}
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    if (indexPath.section == 0)
    {
        if (indexPath.row != 0)
        {
            self.payType = indexPath.row;
            [tableView reloadData];
        }
    }
    else if(indexPath.section == 1)
    {
        [self.viewModel.goodCommand execute:@(indexPath.row - 1)];
    }
}

#pragma mark - tableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
//            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            cell.textLabel.font             = [UIFont wtkNormalFont:14];
            cell.textLabel.textColor        = WTKCOLOR(150, 150, 150, 1);
            UIView *line                    = [[UIView alloc]initWithFrame:CGRectMake(12, 43.6, kWidth - 12, 0.4)];
            line.backgroundColor            = WTKCOLOR(220, 220, 220, 1);
            [cell.contentView addSubview:line];
        }
        if (indexPath.row == 0)
        {
            cell.textLabel.text             = @"请选择支付方式";
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            
        }
        else
        {
            cell.textLabel.text             = self.payTypeArray[indexPath.row - 1];
            cell.imageView.image            = [UIImage imageNamed:self.payImageArray[indexPath.row - 1]];
            if (![cell.contentView viewWithTag:111])
            {
                UIImageView *selectImage    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_pay_normal"]];
                selectImage.frame           = CGRectMake(kWidth - 50, 9.5, 25, 25);
                selectImage.tag             = 111;
                if (indexPath.row ==  self.payType)
                {
                    selectImage.image       = [UIImage imageNamed:@"w_pay_select"];
                }
                [cell.contentView addSubview:selectImage];
            }
            else
            {
                UIImageView *selectImage    = [cell.contentView viewWithTag:111];
                if (indexPath.row ==  self.payType)
                {
                    selectImage.image       = [UIImage imageNamed:@"w_pay_select"];
                }
                else
                {
                    selectImage.image       = [UIImage imageNamed:@"w_pay_normal"];
                }

            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"goodCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodCell"];
                cell.selectionStyle             = UITableViewCellSelectionStyleNone;
                cell.textLabel.font             = [UIFont wtkNormalFont:14];
                cell.textLabel.textColor        = WTKCOLOR(150, 150, 150, 1);
                UIView *line                    = [[UIView alloc]initWithFrame:CGRectMake(12, 43.6, kWidth - 12, 0.4)];
                line.backgroundColor            = WTKCOLOR(220, 220, 220, 1);
                [cell.contentView addSubview:line];
            }
            cell.textLabel.text         = @"商品明细";
        }
        else
        {
            WTKOrderDetailTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"CELL2"];
            if (!cell)
            {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKOrderDetailTableViewCell" owner:nil options:nil];
                cell = array[1];
            }
            [cell updateCell2WithGoods:self.viewModel.goodsArray[indexPath.row - 1]];
            return cell;
        }
    }
    else
    {
//        section2
        cell = [tableView dequeueReusableCellWithIdentifier:@"feeCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feeCell"];
            cell.textLabel.font             = [UIFont wtkNormalFont:14];
            cell.textLabel.textColor        = WTKCOLOR(150, 150, 150, 1);
            UIView *line                    = [[UIView alloc]initWithFrame:CGRectMake(12, 43.6, kWidth - 12, 0.4)];
            line.backgroundColor            = WTKCOLOR(220, 220, 220, 1);
        }
        cell.textLabel.text                 = self.costName[indexPath.row];
        if (![cell.contentView viewWithTag:123])
        {
            UILabel *label                  = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 120, 0, 85, 44)];
            label.textColor                 = THEME_COLOR;
            label.font                      = [UIFont wtkNormalFont:16];
            label.textAlignment             = NSTextAlignmentRight;
            label.text                      = self.costArray[indexPath.row];
            label.tag                       = 123;
            [cell.contentView addSubview:label];
        }
        else
        {
            UILabel *label                  = [cell.contentView viewWithTag:123];
            label.text                      = self.costArray[indexPath.row];
        }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 20)];
    if (section == 0)
    {
        
    }
    header.backgroundColor = WTKCOLOR(240, 240, 240, 1);
    return header;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.viewModel.goodsArray.count + 1 : 4;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row != 0)
    {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    return 20;
}

#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSArray *)payTypeArray
{
    if (!_payTypeArray)
    {
        _payTypeArray = @[@"微信支付",@"支付宝支付",@"货到付款"];
    }
    return _payTypeArray;
}
- (NSArray *)payImageArray
{
    if (!_payImageArray)
    {
        _payImageArray = @[@"w_wechat",@"w_zhifubao",@"w_huodaofukuan"];
    }
    return _payImageArray;
}
- (NSArray *)costName
{
    if (!_costName)
    {
        _costName = @[@"优惠券抵扣",@"积分抵扣",@"配送费",@"总费用"];
    }
    return _costName;
}
- (NSArray *)costArray
{
    if (!_costArray)
    {
        _costArray = @[@"0",@"0",@"0",[NSString stringWithFormat:@"%.2f",self.viewModel.price]];
    }
    return _costArray;
}
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 50, kWidth, 50)];
        _bottomView.backgroundColor = WTKCOLOR(70, 70, 70, 0.8);
    }
    return _bottomView;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWidth * 0.6 - 30, 50)];
    }
    return _priceLabel;
}
- (UIButton *)payBtn
{
    if (!_payBtn)
    {
        _payBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame               = CGRectMake(kWidth * 0.6, 0, kWidth * 0.4, 50);
    }
    return _payBtn;
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
