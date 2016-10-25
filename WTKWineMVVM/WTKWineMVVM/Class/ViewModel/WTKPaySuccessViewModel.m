//
//  WTKPaySuccessViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/25.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPaySuccessViewModel.h"
#import "WTKOrderViewModel.h"
@implementation WTKPaySuccessViewModel

- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:self.services params:params];
    if (self)
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    self.orderCommand       = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKOrderViewModel *viewModel = [[WTKOrderViewModel alloc]initWithService:self.services params:@{@"title":@"全部订单"}];
        viewModel.orderType = 0;
        self.naviImpl.className = @"WTKOrderVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.goHomeCommand      = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [self.naviImpl popToRootViewModelWithAnimation:YES];
        return [RACSignal empty];
    }];
}

@end
