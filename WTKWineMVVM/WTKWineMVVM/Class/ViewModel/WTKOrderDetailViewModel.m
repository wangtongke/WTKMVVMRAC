//
//  WTKOrderDetailViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKOrderDetailViewModel.h"
#import "WTKOrderModel.h"
@implementation WTKOrderDetailViewModel

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
    self.segmentSubject     = [RACSubject subject];
    [self.segmentSubject subscribeNext:^(id x) {
        
        
    }];
    
    self.requestStatusCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        RACSignal *signal   = [WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/order/order_track" withParamater:@{@"orderid":self.order.id}];
        [signal subscribeNext:^(id x) {
            NSLog(@"%@",x);
            if ([x[@"code"] integerValue] == 100)
            {
                NSArray *data = x[@"data"];
                NSMutableArray *array = @[].mutableCopy;
                for (NSDictionary *dic in data)
                {
                    [array addObject:dic];
                }
                self.statusArray = array;
            }
            UITableView *tableView = input;
            if (tableView.mj_header.isRefreshing)
            {
                [tableView.mj_header endRefreshing];
            }
        }];
        return [RACSignal empty];
    }];
    
}

@end
