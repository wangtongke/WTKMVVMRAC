//
//  WTKCommentTableView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentTableView.h"
#import "WTKCommentTableViewCell.h"
#import "WTKComment.h"
@interface WTKCommentTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property(nonatomic,strong)NSMutableDictionary *heightDic;

@property(nonatomic,strong)UIView               *headerView;

@end

@implementation WTKCommentTableView

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
    self.dataSource     = self;
    self.delegate       = self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[WTKCommentTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTKCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WTKComment *commment = self.dataArray[indexPath.row];
    [cell updateWithComment:commment];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;

        WTKComment *comment = self.dataArray[indexPath.row];
        height = [WTKTool calculateStringHeight:comment.content withFont:[UIFont wtkNormalFont:16] stringWidth:kWidth - 30] + 215;
        if (comment.content.length <= 0)
        {
            height = 215;
        }
        if (comment.pic_path.count > 0)
        {
            height = [WTKTool calculateStringHeight:comment.content withFont:[UIFont wtkNormalFont:16] stringWidth:kWidth - 30] + 285;
        }

    
    return height;
}

#pragma mark - DZNEmptyData

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    [[WTKNetWork shareInatance] initNetWork];
    if ([WTKNetWork shareInatance].isNetReachable)
    {
        return [UIImage imageNamed:@"NotWorkViews"];
    }
    return [UIImage imageNamed:@"w_no_msg"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    [[WTKNetWork shareInatance] initNetWork];
    if ([WTKNetWork shareInatance].isNetReachable)
    {
        return [[NSAttributedString alloc]initWithString:@""];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"还没有评论哦"];
    [string addAttribute:NSForegroundColorAttributeName value:WTKCOLOR(70, 70, 70, 1) range:NSMakeRange(0, 6)];
    
    return string;
}

#pragma mark - lazyLoad

- (NSMutableDictionary *)heightDic
{
    if (!_heightDic)
    {
        _heightDic = @{}.mutableCopy;
    }
    return _heightDic;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
