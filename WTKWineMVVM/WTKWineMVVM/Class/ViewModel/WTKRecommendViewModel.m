//
//  WTKRecommendViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/8.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKRecommendViewModel.h"

@implementation WTKRecommendViewModel

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
    self.refershCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [[WTKRequestManager postWithURL:@"http://www.jiuyunda.net:90/api/v1/shareIntegral/share_info" withParamater:@{@"userinfo_id":[WTKUser currentUser].bid,@"customer_id":@"57f8ac945b73294b2d7a97ad"}] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        
        return [RACSignal empty];
    }];
}
@end
