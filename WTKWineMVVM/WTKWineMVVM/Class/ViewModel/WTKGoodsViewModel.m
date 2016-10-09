//
//  WTKGoodsViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGoodsViewModel.h"
#import "WTKGood.h"
#import "WTKShoppingCarViewModel.h"
@implementation WTKGoodsViewModel

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
    self.addCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        [WTKTool beginAddAnimationWithImageView:input animationTime:0.6 startPoint:CGPointMake(kWidth * 4 / 5, kHeight - 25) endPoint:CGPointMake(kWidth * 1.5 / 5, kHeight - 25)];
        [WTKUser currentUser].bageValue ++;
        
        self.goods.num++;
        [[WTKShoppingManager manager].goodsDic setObject:self.goods forKey:self.goods.id];
        
        return [RACSignal empty];
    }];
    
    self.clickShopCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKShoppingCarViewModel *viewModel = [[WTKShoppingCarViewModel alloc]initWithService:nil params:@{@"title":@"购物车"}];
        self.naviImpl.className = @"WTKShoppingCarVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

@end
