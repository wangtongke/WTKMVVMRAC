//
//  WTKMeVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKMeVC.h"
#import "WTKMeTableViewCell.h"
#import "WTKMeBtn.h"
#import "WTKMeHeaderView.h"
#import "WTKMeViewModel.h"

#define FOOT_ID1 @"FOOT1"
#define FOOT_ID2 @"FOOT2"

@interface WTKMeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKMeViewModel       *viewModel;

@property(nonatomic,strong)UITableView          *tableView;

@property(nonatomic,strong)NSArray              *titleArray;

@property(nonatomic,strong)WTKMeHeaderView      *headView;
/**设置按钮*/
@property(nonatomic,strong)UIButton             *setBtn;

@property(nonatomic,assign)BOOL                 dismissFlag;

@end

@implementation WTKMeVC
@dynamic viewModel;
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.dismissFlag = NO;
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 0.02);
    [self.tableView reloadData];
    [_headView update];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.dismissFlag = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, 0.99)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindViewModel];
    [self initView];
    [self resetNavi];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPop) name:@"wtk_cancelPop" object:nil];
}

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        [self updateNavi:x];
    }];
    
    [[self.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.setUpSubject sendNext:x];
    }];
}

- (void)initView
{

    [self.view addSubview:self.tableView];
    _titleArray = @[@"推荐有奖",@"意见反馈",@"客服热线",@"酒运达"];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WTKMeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView  = self.headView;
    
   
}


/**
 * 滑动tableView，更新导航
 */
- (void)updateNavi:(id )x
{
    if (self.dismissFlag)
    {
        return;
    }
    CGPoint point = [x CGPointValue];
    CGFloat y = point.y;
    if (y < 0)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    if (y >= 0)
    {
        float a = y / kWidth / 0.23 > 0.9 ? 0.9 : y / kWidth / 0.23;
        NSLog(@"%f",a);
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WTKCOLOR(70, 70, 70, a)};
        if (a < 0.9 && a >= 0)
        {
            NSLog(@"11111");
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:WTKCOLOR(255, 255, 255, a)] forBarMetrics:UIBarMetricsDefault];
        }
        if (a < 0.5)
        {
            NSLog(@"22222");
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            [self.setBtn setBackgroundImage:[UIImage imageNamed:@"w_shezhi"] forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"333333");
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            [self.setBtn setBackgroundImage:[UIImage imageNamed:@"w_shezhih"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)resetNavi
{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.setBtn setBackgroundImage:[UIImage imageNamed:@"w_shezhi"] forState:UIControlStateNormal];
    self.setBtn.frame               = CGRectMake(0, 0, 25, 23);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.setBtn];
}

- (void)cancelPop
{
    [self resetNavi];
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.cellClickSubject sendNext:@(indexPath.row + indexPath.section)];
    if (indexPath.row == 2)
    {
//        客服热线
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"telprompt://10086"];
            [[UIApplication sharedApplication] openURL:url];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服热线" message:@"全国客服热线：10086" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:action];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - tableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 2)
    {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.05)];
    }
    else
    {
        if (section == 0)
        {
            footView    = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOT_ID1];
        }
        else
        {
            footView    = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOT_ID2];
        }
        
        if (!footView)
        {
            footView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 95)];
            NSArray *titleArray = section == 0 ? @[@"待支付",@"配送中",@"已配送",@"待评价"] : @[@"积分",@"酒库",@"优惠券",@"酒券"];
            NSArray *imgArray   = section == 0 ? @[@"w_daizhifu",@"w_peisongzhong",@"w_yipeisong",@"w_daipingjia"] : @[@"w_jifen",@"w_jiuku",@"w_youhuiquan",@"w_jiuquan"];
            CGFloat height  = 80;
            CGFloat width   = kWidth / 4.0;
            @weakify(self);
            [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WTKMeBtn *btn = [WTKMeBtn buttonWithTitle:obj imageName:imgArray[idx]];
                btn.tag     = idx;
                [btn setFrame:CGRectMake(idx * width, 0, width, height)];
                [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    [self.viewModel.headClickSubject sendNext:@(idx + section * 4)];
                }];
                [footView addSubview:btn];
                if (idx == 3 && section == 0)
                {
                    btn.bageValue = 2;
                }
            }];
            UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 79.4, kWidth, 15.6)];
            bottom.backgroundColor = BASE_COLOR;
            [footView addSubview:bottom];
        }
    }
    
    
    
    
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKMeTableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0)
    {
        [cell updateTitle:@"我的订单" subTitle:@"查看全部订单"];
    }
    else if (indexPath.section == 1)
    {
        [cell updateTitle:@"我的钱包" subTitle:@"查看明细"];
    }
    else
    {
        [cell updateTitle:self.titleArray[indexPath.row] subTitle:@""];
        if (indexPath.row == 2)
        {
            [cell updateTitle:self.titleArray[indexPath.row] subTitle:@"QQ81520140"];
        }
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : section == 1 ? 1 : 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return section == 2 ? 0.1 : 95;
}


#pragma mark - lazyLoad

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 49) style:UITableViewStylePlain];
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIView *)headView
{
    if (!_headView)
    {
        _headView = [[WTKMeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
        _headView.viewModel = self.viewModel;
        [_headView update];
    }
    return _headView;
}
- (UIButton *)setBtn
{
    if (!_setBtn)
    {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _setBtn;
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
