//
//  WTKOrderStateTableView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderStateTableView.h"
#import "WTKOrderStateTableViewCell.h"
#import "WTKOrderModel.h"

@interface WTKOrderStateTableView ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WTKOrderStateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self config];
    }
    return self;
}

- (void)config
{
    self.dataSource         = self;
    self.delegate           = self;
    [self registerNib:[UINib nibWithNibName:@"WTKOrderStateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.rowHeight          = 50;
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKOrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (indexPath.row == 0)
    {
        cell.w_topLine.hidden           = YES;
        cell.w_tatusImageView.hidden    = YES;
        UIImageView *imageVIew          = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_dian4"]];
        imageVIew.tag                   = 100;
        CGPoint center                  = cell.w_tatusImageView.center;
        imageVIew.bounds                = CGRectMake(0, 0, 16, 17);
        imageVIew.center                = center;
        [cell.contentView addSubview:imageVIew];
        if(self.dataArray.count == 1)
        {
            cell.w_bottomLine.hidden    = YES;
        }
    }
    else if (indexPath.row == self.dataArray.count - 1 && indexPath.row != 0)
    {
        cell.w_tatusImageView.hidden    = NO;
        cell.w_bottomLine.hidden        = YES;
        cell.w_topLine.hidden           = NO;
        cell.w_tatusImageView.image     = [UIImage imageNamed:@"w_dian"];
    }
    else
    {
        cell.w_tatusImageView.hidden    = NO;
        cell.w_bottomLine.hidden        = NO;
        cell.w_topLine.hidden           = NO;
        cell.w_tatusImageView.image     = [UIImage imageNamed:@"w_dian"];
    }
    cell.w_timeLabel.text               = self.dataArray[self.dataArray.count - 1 - indexPath.row][@"created_at"];
    cell.w_statusLabel.text             = self.dataArray[self.dataArray.count - 1 - indexPath.row][@"remarks"];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    
    if ([headView viewWithTag:100])
    {
        UILabel *typeLable  = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 150, 15)];
        NSInteger type      = [self.order.paymode integerValue];
        typeLable.tag       = 100;
        NSString *title     = type == 0 ? @"货到付款" : type == 1 ? @"支付宝支付" : @"微信支付";
        if ([self.order.workflow_state isEqualToString:@"generation"])
        {
            typeLable.text  = @"未支付订单";
        }
        typeLable.text      = [NSString stringWithFormat:@"支付方式:%@",title];
        typeLable.textColor = WTKCOLOR(100, 100, 100, 1);
        typeLable.font      = [UIFont wtkNormalFont:14];
        [headView addSubview:typeLable];
        
        UILabel *noLabel    = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 300, 15)];
        noLabel.text        = [NSString stringWithFormat:@"订单编号:%@",self.order.orderno];
        noLabel.textColor   = WTKCOLOR(100, 100, 100, 1);
        noLabel.font        = [UIFont wtkNormalFont:14];
        [headView addSubview:noLabel];
    }
    
    return headView;
}




@end
