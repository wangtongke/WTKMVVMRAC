//
//  WTKSiftView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSiftView.h"
#import "WTKSiftModel.h"
#import "WTKSiftTableViewCell.h"

@interface WTKSiftView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView                  *tableView;

///用来记录当前区是否展开
@property(nonatomic,strong)NSMutableDictionary          *onDic;

///已选择的内容
@property(nonatomic,strong)NSArray<NSMutableArray *>    *selectedArray;

@property(nonatomic,strong)UIView                       *headerView;

@property(nonatomic,strong)UIView                       *footView;

@end

@implementation WTKSiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor        = WTKCOLOR(70, 70, 70, 0.8);
        self.dismissSubject         = [RACSubject subject];
        [self configView];
    }
    return self;
}

- (void)configView
{
    [self addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight        = 44;
    [self.tableView registerNib:[UINib nibWithNibName:@"WTKSiftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView  = self.headerView;
    self.tableView.tableFooterView  = self.footView;
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         self.frame = CGRectMake(kWidth / 2.0 + 40, 0, kWidth, kHeight - 64 - 49);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.backgroundColor = WTKCOLOR(70, 70, 70, 0.8);
                         self.frame = CGRectMake(0, 0, kWidth, kHeight - 64 - 49);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
    [self.dismissSubject sendNext:@100];
}

- (void)topBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
//            取消
            [self dismiss];
            [self.dismissSubject sendNext:@100];
        }
            break;
        case 2:
        {
//            确定
            [self dismiss];
            [self.dismissSubject sendNext:@100];
        }
            break;
        case 3:
        {
//            清空选项
            [self.selectedArray enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *array = obj;
                [array removeAllObjects];
            }];
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj[@"data"];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WTKSiftModel *model = obj;
                    model.isSelected = NO;
                }];
            }];
            [self reloadData];
        }
            break;
        default:
            break;
    }
}
- (void)headerClick:(UIButton *)btn
{
    NSString *section = [NSString stringWithFormat:@"%ld",btn.tag];
    if (self.onDic[section])
    {
        [self.onDic removeObjectForKey:section];
    }
    else
    {
        self.onDic[section] = @"有了";
    }
    [self reloadData];
}
- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKSiftModel *model             = self.dataArray[indexPath.section][@"data"][indexPath.row];
    model.isSelected                = !model.isSelected;
    WTKSiftTableViewCell *cell      = [tableView cellForRowAtIndexPath:indexPath];
    [cell updateWithModel:model];
//    更新区头title
    NSMutableArray *array           = self.selectedArray[indexPath.section];
    if (model.isSelected)
    {
        [array addObject:model.name];
    }
    else
    {
        [array removeObject:model.name];
    }
}

#pragma mark - tableDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    header.backgroundColor          = [UIColor whiteColor];
    UILabel *titleLabel             = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 40, 30)];
    titleLabel.text                 = self.dataArray[section][@"name"];
    titleLabel.font                 = [UIFont wtkNormalFont:16];
    titleLabel.textColor            = WTKCOLOR(80, 80, 80, 1);
    [header addSubview:titleLabel];
    
    UIImageView *imageView          = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 35, 17.5, 15, 15)];
    imageView.image                 = self.onDic[[NSString stringWithFormat:@"%ld",section]] ? [UIImage imageNamed:@"w_xia"] : [UIImage imageNamed:@"w_right"];

    [header addSubview:imageView];
    
    UILabel *subTitle               = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, tableView.frame.size.width - 60 - 38, 30)];
    subTitle.font                   = [UIFont wtkNormalFont:13];
    subTitle.textColor              = WTKCOLOR(100, 100, 100, 1);
    subTitle.textAlignment          = NSTextAlignmentRight;
    NSArray *array                  = self.selectedArray[section];NSLog(@"%ld,%@",section,array);
   __block NSString *title                 = @"";
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= 2)
        {
            return ;
        }
        title = [title stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
    }];
    if ([title hasSuffix:@","])
    {
        title                       = [title substringToIndex:title.length - 1];
    }
    if (array.count > 2)
    {
        title = [title stringByAppendingString:@"等"];
    }
    subTitle.text                   = title;
    [header addSubview:subTitle];
//    线
    UIView *line                    = [[UIView alloc]initWithFrame:CGRectMake(10, 49.5, tableView.frame.size.width - 10, 0.5)];
    line.backgroundColor            = WTKCOLOR( 150, 150, 150, 1);
    [header addSubview:line];
    UIButton *btn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                       = header.frame;
    btn.tag                         = section;
    [btn addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKSiftTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    WTKSiftModel *model             = self.dataArray[indexPath.section][@"data"][indexPath.row];
    [cell updateWithModel:model];
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.onDic[[NSString stringWithFormat:@"%ld",section]])
    {
        NSArray *array = self.dataArray[section][@"data"];
        return array.count;
    }
    else
    {
        return 0;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - lazyLoad

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kWidth / 2.0 - 40,0, kWidth / 2.0 + 40, self.frame.size.height)];
    }
    return _tableView;
}
- (NSMutableDictionary *)onDic
{
    if (!_onDic)
    {
        _onDic = @{}.mutableCopy;
    }
    return _onDic;
}
- (NSArray<NSMutableArray *> *)selectedArray
{
    if (!_selectedArray)
    {
        _selectedArray = @[@[].mutableCopy,@[].mutableCopy,@[].mutableCopy,@[].mutableCopy];
    }
    return _selectedArray;
}
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        UIButton *cancelBtn             = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame                 = CGRectMake(20, 20, 40, 30);
        cancelBtn.titleLabel.font       = [UIFont wtkNormalFont:16];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:WTKCOLOR(80, 80, 80, 1) forState:UIControlStateNormal];
        cancelBtn.tag                   = 1;
        [cancelBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:cancelBtn];
        
        UILabel *titleLabel             = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, self.tableView.frame.size.width - 120, 30)];
        titleLabel.textAlignment        = NSTextAlignmentCenter;
        titleLabel.text                 = @"筛选";
        titleLabel.textColor            = WTKCOLOR(30, 30, 30, 1);
        titleLabel.font                 = [UIFont wtkNormalFont:20];
        [self.headerView addSubview:titleLabel];
        
        UIButton *confirmBtn            = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame                = CGRectMake(self.tableView.frame.size.width - 64, 20, 40, 30);
        confirmBtn.titleLabel.font      = [UIFont wtkNormalFont:16];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:WTKCOLOR(80, 80, 80, 1) forState:UIControlStateNormal];
        confirmBtn.tag                  = 2;
        [confirmBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:confirmBtn];
    }
    return _headerView;
}
- (UIView *)footView
{
    if (!_footView)
    {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
        UIButton *btn                   = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame                       = CGRectMake(50, 42, self.tableView.frame.size.width - 100, 36);
        btn.tag                         = 3;
        btn.layer.cornerRadius          = 5;
        btn.layer.masksToBounds         = YES;
        btn.backgroundColor             = WTKCOLOR(230, 230, 230, 1);
        btn.titleLabel.font             = [UIFont wtkNormalFont:19];
        [btn setTitleColor:WTKCOLOR(110, 110, 110, 1) forState:UIControlStateNormal];
        [btn setTitle:@"清空选项" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        
        
    }
    return _footView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
