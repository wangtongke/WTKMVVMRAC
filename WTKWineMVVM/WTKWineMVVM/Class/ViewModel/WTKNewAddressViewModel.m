//
//  WTKNewAddressViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKNewAddressViewModel.h"

@implementation WTKNewAddressViewModel

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
    self.saveCommand    = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        return [RACSignal empty];
    }];
    
    self.addressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        return [RACSignal empty];
    }];
    
}

@end
