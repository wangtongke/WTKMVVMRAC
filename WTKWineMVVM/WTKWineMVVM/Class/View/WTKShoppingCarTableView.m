//
//  WTKShoppingCarTableView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/21.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKShoppingCarTableView.h"
#import "WTKShoppingCarTableViewCell.h"
#import "WTKGoodManagerView.h"
#import "WTKShoppingCarViewModel.h"
#import "WTKEmptyShoppingCarView.h"

@interface WTKShoppingCarTableView ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITextField  *remarkTXF;

@end

@implementation WTKShoppingCarTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.delegate       = self;
    self.dataSource     = self;
    
    UIView *footView    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    [footView addSubview:self.remarkTXF];
    self.tableFooterView = footView;
    
    self.remarkTXF.frame = CGRectMake(10, 8, kWidth - 20, 40);
    self.remarkTXF.placeholder          = @"给商家留言（选填）";
    self.remarkTXF.layer.cornerRadius   = 5;
    self.remarkTXF.layer.masksToBounds  = YES;
    self.remarkTXF.layer.borderColor    = WTKCOLOR(190, 190, 190, 1).CGColor;
    self.remarkTXF.layer.borderWidth    = 0.4;
    
    self.emptyDataSetSource             = self;
    self.emptyDataSetDelegate           = self;
    

}
- (void)w_reloadData
{   SHOPPING_MANAGER.flag = NO;
    NSDictionary *dic = SHOPPING_MANAGER.goodsDic;
    self.dataArray = [dic allValues];
    [self reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        地址
        [self.viewModel.addressCommand execute:@1];
    }
    else
    {
        [self.viewModel.goodClickCommand execute:self.dataArray[indexPath.row]];
    }
    
}

#pragma mark - tableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKShoppingCarTableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
         NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKShoppingCarTableViewCell" owner:nil options:nil];
        cell = array[1];
        cell.address = self.viewModel.address;
    }
    else
    {
         NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKShoppingCarTableViewCell" owner:nil options:nil];
        cell = array[0];
        WTKGood *good = self.dataArray[indexPath.row];
        [cell.w_managView.addSubject subscribeNext:^(id x) {
            [self w_reloadData];
        }];
        [cell.w_managView.reduceSubject subscribeNext:^(id x) {
            [self w_reloadData];
        }];
        [cell updateWithGood:good];
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0)
    {
        return 0;
    }
    if (section == 0)
    {
        return 1;
    }
    return self.dataArray.count;
}
 -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 90;
    }
    return 100;
}

# pragma mark - lazyLoad
- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[WTKShoppingManager manager].goodsDic allValues];
    }
    return _dataArray;
}
- (UITextField *)remarkTXF
{
    if (!_remarkTXF)
    {
        _remarkTXF = [[UITextField alloc]init];
    }
    return _remarkTXF;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
