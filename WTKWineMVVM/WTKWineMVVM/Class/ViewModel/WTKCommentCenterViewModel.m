//
//  WTKCommentCenterViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentCenterViewModel.h"
#import "WTKOrderModel.h"
#import "WTKOrderDetailViewModel.h"
#import "WTKCommentViewModel.h"
@implementation WTKCommentCenterViewModel

- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:service params:params];
    if (self)
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SHOW_SVP(@"加载中")
        RACSignal *signal = [WTKRequestManager postArrayDataWithURL:@"AllOrder" withpramater:@{}];
        [signal subscribeNext:^(id x) {
            DISMISS_SVP(0.01);
            UITableView *table = input;
            if (table.mj_header.isRefreshing)
            {
                [table.mj_header endRefreshing];
            }
            NSArray *xArray = x;
            NSMutableArray *mArray = @[].mutableCopy;
            for (NSDictionary *dic in xArray)
            {
                WTKOrderModel *order = [[WTKOrderModel alloc]initWithDic:dic];
                [mArray addObject:order];
            }
            self.dataArray = mArray;
        }];
        return [RACSignal empty];
    }];
    
    self.cellClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKOrderDetailViewModel *viewModel = [[WTKOrderDetailViewModel alloc]initWithService:self.services params:@{@"title":@"订单详情"}];
        viewModel.order = input;
        self.naviImpl.className = @"WTKOrderDetailVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];

    self.commentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKCommentViewModel *viewModel = [[WTKCommentViewModel alloc]initWithService:self.services params:@{@"title":@"评价"}];
        viewModel.order = input;
        self.naviImpl.className = @"WTKCommentVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}



#pragma lazyLoad
-(NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
