//
//  WTKFunctionVC.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKFunctionVC.h"
#import "WTKFunctionViewModel.h"


@interface WTKFunctionVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)WTKFunctionViewModel *viewModel;

@property(nonatomic,strong)UITableView *tableView;

@end
@implementation WTKFunctionVC
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self initView];
}
- (void)bindViewModel
{
    [super bindViewModel];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.rowHeight        = 50;
    
    UIView *headerView              = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    UILabel *label                  = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, kWidth - 22, 30)];
    label.text                      = @"设置系统提示音、震动和指纹支付";
    label.textColor                 = WTKCOLOR(120, 120, 120, 1);
    label.font                      = [UIFont wtkNormalFont:14];
    [headerView addSubview:label];
    self.tableView.tableHeaderView  = headerView;
}
- (void)switchClick:(UISwitch *)sender
{
    [self.viewModel.switchCommand execute:sender];
}


#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell                    = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor= WTKCOLOR(70, 70, 70, 1);
        cell.textLabel.text     = indexPath.row == 0? @"声音" : indexPath.row == 1 ? @"震动" : @"指纹支付";
        UISwitch *sw            = [[UISwitch alloc]initWithFrame:CGRectMake(kWidth - 70, 10, 50, 30)];
        sw.tintColor            = THEME_COLOR;
        sw.tag                  = indexPath.row;
        [sw setOnTintColor:THEME_COLOR];
        [sw addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0)
        {
            sw.on               = CURRENT_USER.isSound;
        }
        else if (indexPath.row == 1)
        {
            sw.on               = CURRENT_USER.isShake;
        }
        else
        {
            sw.on               = CURRENT_USER.isTouchID;
        }
        [cell.contentView addSubview:sw];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}



- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    return _tableView;
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
