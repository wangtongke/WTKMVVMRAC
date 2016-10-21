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

@interface WTKShoppingCarTableView ()<UITableViewDataSource,UITableViewDelegate>

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
    
    
    

}
- (void)w_reloadData
{   SHOPPING_MANAGER.flag = NO;
    NSDictionary *dic = SHOPPING_MANAGER.goodsDic;
    self.dataArray = [dic allValues];
    [self reloadData];
}

#pragma mark - tableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKShoppingCarTableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
         NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"WTKShoppingCarTableViewCell" owner:nil options:nil];
        cell = array[1];
        cell.w_nameLabel.text   = CURRENT_USER.nickName;
        cell.w_phoneLabel.text  = CURRENT_USER.phoneNum;
        cell.w_addressLabel.text= @"重庆市渝北区";
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
