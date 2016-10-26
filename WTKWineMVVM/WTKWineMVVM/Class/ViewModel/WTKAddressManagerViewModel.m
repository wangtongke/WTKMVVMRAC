//
//  WTKAddressManagerViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/25.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAddressManagerViewModel.h"
#import "WTKNewAddressViewModel.h"
@implementation WTKAddressManagerViewModel

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
    self.addAddressCommand      = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKNewAddressViewModel *viewModel = [[WTKNewAddressViewModel alloc]initWithService:self.services params:@{@"title":@"新建地址"}];
        self.naviImpl.className = @"WTKNewAddressVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        
        
        return [RACSignal empty];
    }];
}

@end
