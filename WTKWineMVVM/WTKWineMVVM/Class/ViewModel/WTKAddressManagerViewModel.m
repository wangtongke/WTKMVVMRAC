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
    @weakify(self);
    self.addAddressCommand      = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKNewAddressViewModel *viewModel = [[WTKNewAddressViewModel alloc]initWithService:self.services params:@{@"title":@"新建地址"}];
        self.naviImpl.className = @"WTKNewAddressVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        
        
        return [RACSignal empty];
    }];
    
    self.editAddress            = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKNewAddressViewModel *viewModel = [[WTKNewAddressViewModel alloc]initWithService:self.services params:@{@"title":@"新建地址"}];
        viewModel.address = input;
        self.naviImpl.className = @"WTKNewAddressVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.deleteAddress          = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [CURRENT_USER.address removeObject:input];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"删"];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    self.cellClickCommand       = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSLog(@"13");
        if (self.isShoppingCar)
        {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                [self.naviImpl popViewControllerWithAnimation:YES];
                return nil;
            }];
            return signal;
        }
        return [RACSignal empty];
    }];
}

@end
