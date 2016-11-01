//
//  WTKCommentTableView.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/11/1.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentTableView.h"
#import "WTKComment.h"
@interface WTKCommentTableView ()<UITableViewDelegate,UITableViewDataSource>



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
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - lazyLoad
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (NSDictionary *)titleDic
{
    if (!_titleDic)
    {
        _titleDic = @{@"bad":@"0",
                      @"good":@"0",
                      @"middle":@"0",
                      @"picture":@"0",
                      @"whole":@"0"};
    }
    return _titleDic;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
