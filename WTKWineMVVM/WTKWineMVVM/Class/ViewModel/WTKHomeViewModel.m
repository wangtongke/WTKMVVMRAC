//
//  WTKHomeViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKHomeViewModel.h"
#import "WTKGoodsViewModel.h"
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
        
//        RACSignal *signal1 = [WTKRequestManager postArrayDataWithURL:HOME_HEAD withpramater:nil];
        RACSignal *signal1 = [WTKRequestManager getWithURL:@"http://www.jiuyunda.net:90/api/v1/product/slideshow" withParamater:@{@"id":@"56c45924c2fb4e2050000022"}];
        RACSignal *signal2 = [WTKRequestManager postArrayDataWithURL:Home_Data withpramater:nil];
        
        RACSignal *signal3 = [self rac_liftSelector:@selector(updateData:headDic:) withSignalsFromArray:@[signal1,signal2]];
        [signal3 subscribeNext:^(id x) {
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
        return [RACSignal empty];
    }];
    
    self.goodCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:nil params:@{@"title":@"商品详情"}];
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.naviCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UIButton *btn = input;
        return [RACSignal empty];
    }];
    
    self.searchSubject  = [RACSubject subject];
    [self.searchSubject subscribeNext:^(id x) {
//       跳转搜索界面
        NSLog(@"dainji ");
    }];

}

- (void)updateData:(NSArray *)headArray headDic:(NSArray *)dataArray
{
    self.headData = headArray;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dataArray)
    {
        WTKGood *good = [[WTKGood alloc]initWithDic:dic];
        [array addObject:good];
        
    }
    self.dataArray = [NSArray arrayWithArray:array];
}




@end
