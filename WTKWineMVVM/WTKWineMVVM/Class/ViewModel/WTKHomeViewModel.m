//
//  WTKHomeViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeViewModel.h"
#import "WTKGoodsViewModel.h"
#import "WTKRecommendViewModel.h"
#import "WTKOrderViewModel.h"
#import "WTKWebViewModel.h"
#import "WTKSearchViewModel.h"
#import "WTKQRCodeViewModel.h"
@interface WTKHomeViewModel ()



@end

@implementation WTKHomeViewModel

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
    self.refreshCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SHOW_SVP(@"加载中");
//        RACSignal *signal1 = [WTKRequestManager postArrayDataWithURL:HOME_HEAD withpramater:nil];
        RACSignal *signal1 = [WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/product/slideshow" withParamater:@{@"id":CURRENT_USER.bid}];
        [signal1 subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        RACSignal *signal2 = [WTKRequestManager postArrayDataWithURL:Home_Data withpramater:nil];
        
        RACSignal *signal3 = [self rac_liftSelector:@selector(updateData:headDic:) withSignalsFromArray:@[signal1,signal2]];
        [signal3 subscribeNext:^(id x) {
            [SVProgressHUD dismiss];
            UICollectionView *collectionView = input;
            if (collectionView.mj_header.isRefreshing)
            {
                [collectionView reloadData];
                [collectionView.mj_header endRefreshing];
            }
        }];
        return signal3;
        
//        return signal;
    }];
    
//    [[self.refreshCommand.executing skip:1] subscribeNext:^(id x) {
//        if ([x boolValue])
//        {
////            正在执行
//            [SVProgressHUD showWithStatus:@"正在加载"];
//        }
//        else
//        {
//            [SVProgressHUD dismiss];
//        }
//    }];
    
    self.headCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        return [RACSignal empty];
    }];
    
    self.btnCommand     = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        NSInteger tag   = [input integerValue];
        switch (tag) {
            case 100:
            {
                
            }
                break;
            case 101:
            {
                WTKRecommendViewModel *viewModel = [[WTKRecommendViewModel alloc]initWithService:self.services params:@{@"title":@"推荐有奖"}];
                self.naviImpl.className = @"WTKRecommendVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];

            }
                break;
            case 102:
            {
                
            }
                break;
            case 103:
            {
                WTKOrderViewModel *viewModel = [[WTKOrderViewModel alloc]initWithService:self.services params:@{@"title":@"全部订单"}];
                viewModel.orderType = 0;
                self.naviImpl.className = @"WTKOrderVC";
                [self.naviImpl pushViewModel:viewModel animated:YES];
            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
    self.goodCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:nil params:@{@"title":@"商品详情"}];
        viewModel.goods = (WTKGood *)input;
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.naviCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UIButton *btn = input;
        if (btn.tag == 111)
        {
//            erweima
            WTKQRCodeViewModel *viewModel = [[WTKQRCodeViewModel alloc]initWithService:self.services params:@{@"title":@"二维码"}];
            self.naviImpl.className = @"WTKQRCodeVC";
            [self.naviImpl pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    
    self.searchSubject  = [RACSubject subject];
    [self.searchSubject subscribeNext:^(id x) {
//       跳转搜索界面
        WTKSearchViewModel *viewModel = [[WTKSearchViewModel alloc]initWithService:self.services params:@{@"title":@"搜索"}];
        self.naviImpl.className = @"WTKSearchVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
    }];

}

- (void)updateData:(id)headArray headDic:(NSArray *)dataArray
{
#warning 以后修改
//    return;
    if ([headArray[@"code"] integerValue] == 100)
    {
        self.headData = headArray[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dataArray)
        {
            WTKGood *good = [[WTKGood alloc]initWithDic:dic];
            [array addObject:good];
            
        }
        self.dataArray = [NSArray arrayWithArray:array];
    }
    else
    {
        self.headData = [NSArray array];
        self.dataArray = [NSArray array];
    }
    
}




@end
