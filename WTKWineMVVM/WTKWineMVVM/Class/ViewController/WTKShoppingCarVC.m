//
//  WTKShoppingCarVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/22.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKShoppingCarVC.h"
#import "WTKShoppingCarViewModel.h"
#import "WTKShoppingCarTableView.h"
@interface WTKShoppingCarVC ()

@property(nonatomic,strong)WTKShoppingCarViewModel  *viewModel;

@property(nonatomic,strong)WTKShoppingCarTableView  *tableView;

@property(nonatomic,strong)UIView                   *bottomView;

///总价
@property(nonatomic,strong)UILabel                  *priceLabel;

@property(nonatomic,strong)UIButton                 *payBtn;

@property(nonatomic,strong)UIButton                 *selectAllBtn;

///判断当前事件是否为点击
@property(nonatomic,assign)BOOL                     isClickAllBtn;



@end

@implementation WTKShoppingCarVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView w_reloadData];
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
// - 监听价格
    [RACObserve([WTKShoppingManager manager], changed) subscribeNext:^(id x) {
        static BOOL isFirst;//是否是第一次检测到没有选中。用来避免多次改变selectAllBtn
        isFirst                 = YES;
        SHOPPING_MANAGER.flag   = YES;
        NSDictionary *dic       = SHOPPING_MANAGER.goodsDic;
        [[dic allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            WTKGood *good = obj;
            if(isFirst && !good.w_isSelected && !self.isClickAllBtn)
            {
                self.selectAllBtn.selected = !self.selectAllBtn;
                isFirst = NO;
            }
            if (idx == 0)
            {
                SHOPPING_MANAGER.price = 0;
            }
            if (good.w_isSelected)
            {
                SHOPPING_MANAGER.price += good.price * good.num;
            }
            if(idx == [dic allValues].count - 1)
            {
                self.isClickAllBtn = NO;
            }
            self.priceLabel.text    = [NSString stringWithFormat:@"共¥ %.2f",SHOPPING_MANAGER.price];
        }];
//        SHOPPING_MANAGER.flag = NO;
    }];
    
//    全选按钮
    [[self.selectAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isClickAllBtn = YES;
        UIButton *btn = x;
        btn.selected = !btn.selected;
        SHOPPING_MANAGER.flag = NO;
        NSArray *array = [SHOPPING_MANAGER.goodsDic allValues];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTKGood *good = obj;
            good.w_isSelected = btn.selected;
            if (idx == array.count - 1)
            {
                [self.tableView w_reloadData];
                SHOPPING_MANAGER.goodsDic;
            }
        }];
    }];
}

- (void)initView
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, 1)};
    
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.bottomView];
    
    _bottomView.backgroundColor = WTKCOLOR(70, 70, 70, 0.8);
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.payBtn];
    [self.bottomView addSubview:self.selectAllBtn];
    self.priceLabel.textColor   = WTKCOLOR(252, 252, 252, 1);
    self.priceLabel.font        = [UIFont wtkNormalFont:15];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    self.payBtn.titleLabel.font = [UIFont wtkNormalFont:16];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payBtn setTitle:@"选好了" forState:UIControlStateNormal];
    self.payBtn.backgroundColor = THEME_COLOR;
    
    
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[WTKShoppingCarTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 40) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 49 - 50, kWidth, 50)];
    }
    return _bottomView;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, kWidth * 0.6 - 90, 50)];
    }
    return _priceLabel;
}
- (UIButton *)payBtn
{
    if (!_payBtn)
    {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame  = CGRectMake(kWidth * 0.6, 0, kWidth * 0.4, 50);
    }
    return _payBtn;
}
- (UIButton *)selectAllBtn
{
    if (!_selectAllBtn)
    {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame = CGRectMake(8, 15, 20, 20);
        [_selectAllBtn setBackgroundImage:[UIImage imageNamed:@"w_pay_normal"] forState:UIControlStateNormal];
        [_selectAllBtn setBackgroundImage:[UIImage imageNamed:@"w_pay_select"] forState:UIControlStateSelected];
        _selectAllBtn.backgroundColor = [UIColor whiteColor];
        _selectAllBtn.layer.cornerRadius = 10;
        _selectAllBtn.layer.masksToBounds = YES;
    }
    return _selectAllBtn;
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
