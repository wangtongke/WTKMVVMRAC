//
//  WTKShoppingCarViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKShoppingCarViewModel.h"
#import "WTKGoodsViewModel.h"
#import "WTKPayViewModel.h"
#import "WTKAddressManagerViewModel.h"


@implementation WTKShoppingCarViewModel

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
    self.emptySubject           = [RACSubject subject];
// - 监听价格
    [RACObserve([WTKShoppingManager manager], changed) subscribeNext:^(id x) {
        static BOOL isFirst;//是否是第一次检测到没有选中。用来避免多次改变selectAllBtn
        isFirst                 = YES;
        SHOPPING_MANAGER.flag   = YES;
        NSDictionary *dic       = SHOPPING_MANAGER.goodsDic;
        [[dic allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            WTKGood *good = obj;
            if(isFirst && !good.w_isSelected && !self.isClickAllBtn)
            {
//                self.selectAllBtn.selected = !self.selectAllBtn;
                isFirst = NO;
                self.btnState = NO;
            }
            if (idx == 0)
            {
                SHOPPING_MANAGER.price = 0;
            }
            if (good.w_isSelected)
            {
                SHOPPING_MANAGER.price += good.price * good.num;
            }
            if (idx == [dic allValues].count - 1 && isFirst && !self.isClickAllBtn)
            {
                self.btnState = YES;
            }
            if(idx == [dic allValues].count - 1)
            {
                //                self.isClickAllBtn = NO;
                self.isClickAllBtn = NO;
            }
//            self.priceLabel.text    = [NSString stringWithFormat:@"共¥ %.2f",SHOPPING_MANAGER.price];
            self.price = [NSString stringWithFormat:@"共¥ %.2f",SHOPPING_MANAGER.price];
        }];
            SHOPPING_MANAGER.flag = NO;
        [self.emptySubject sendNext:@([dic allValues].count)];

    }];
    
    self.goodClickCommand       = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:self.services params:@{@"title":@"商品详情"}];
        viewModel.goods = (WTKGood *)input;
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.addressCommand         = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            WTKAddressManagerViewModel *viewModel = [[WTKAddressManagerViewModel alloc]initWithService:self.services params:@{@"title":@"选择地址"}];
            viewModel.isShoppingCar = YES;
            [viewModel.cellClickCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                self.address = x;
            }];
            self.naviImpl.className = @"WTKAddressManagerVC";
            [self.naviImpl pushViewModel:viewModel animated:YES];

        
        return [RACSignal empty];
    }];
    
    self.payCommand             = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//        是否登录
        if ([self judgeWhetherLogin:YES])
        {
            //        跳转支付
            if ([[self.price substringFromIndex:2] floatValue] > 0)
            {
                WTKPayViewModel *viewModel = [[WTKPayViewModel alloc]initWithService:self.services params:@{@"title":@"结算付款"}];
                self.naviImpl.className = @"WTKPayVC";
                NSMutableArray *array = @[].mutableCopy;
                [[SHOPPING_MANAGER.goodsDic allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WTKGood *good = obj;
                    if (good.w_isSelected)
                    {
                        [array addObject:obj];
                    }
                }];
                viewModel.goodsArray = array;
                [self.naviImpl pushViewModel:viewModel animated:YES];
                
            }
            else
            {
                SHOW_ERROE(@"您还没有选择物品");
                DISMISS_SVP(1.3);
            }
        }
        

        return [RACSignal empty];
    }];
    
}
- (WTKAddress *)address
{
    if (!_address)
    {
        _address = CURRENT_USER.defaultAddress;
    }
    return _address;
}

@end
