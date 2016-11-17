//
//  WTKPayViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/24.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPayViewModel.h"
#import "WTKGoodsViewModel.h"
#import "WTKPaySuccessViewModel.h"
#import "WTKOrderModel.h"
@implementation WTKPayViewModel

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
    self.payCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (CURRENT_USER.isTouchID)
        {
            [WTKTool testTouchIDWithCompleteBlock:^(BOOL flag) {
                if (flag)
                {
                    NSInteger payType = [input integerValue];
                    SHOW_SVP(@"正在生成订单");
                    NSString *tip = payType == 1 ? @"微信支付成功" : payType == 2 ? @"支付宝支付成功" : @"支付成功";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        SHOW_SUCCESS(tip);
                        DISMISS_SVP(1.2);
                        [SHOPPING_MANAGER refreshGoods];
                        WTKPaySuccessViewModel *viewModel = [[WTKPaySuccessViewModel alloc]initWithService:self.services params:@{@"title":@"付款成功"}];
                        WTKOrderModel *model = [[WTKOrderModel alloc]initWithDic:@{@"ordertype":@(payType),@"paycost":[NSString stringWithFormat:@"%.2f",self.price]}];
                        viewModel.orderModel = model;
                        self.naviImpl.className = @"WTKPaySuccessVC";
                        [self.naviImpl pushViewModel:viewModel animated:YES];
                        
                    });
                }
            }];
        }
        else
        {
            SHOW_ERROE(@"请前往设置页面\n开通指纹支付");
            DISMISS_SVP(1.9);
        }
        return [RACSignal empty];
    }];
    
    self.goodCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"good");
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:self.services params:@{@"title":@"GoodsMessage"}];
        viewModel.goods = self.goodsArray[[input integerValue]];
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}


#pragma mark - lazyLoad
- (CGFloat)price
{
    int a = 0;
    for (WTKGood *good in self.goodsArray)
    {
        a += good.price * good.num;
    }
    return a;
}
@end
