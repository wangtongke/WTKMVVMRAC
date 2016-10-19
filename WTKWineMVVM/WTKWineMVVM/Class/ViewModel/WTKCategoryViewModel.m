//
//  WTKCategoryViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCategoryViewModel.h"
#import "WTKGoodsViewModel.h"
@interface WTKCategoryViewModel ()



@end

@implementation WTKCategoryViewModel

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
    @weakify(self);
    self.refreshCommand     = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        SHOW_SVP(@"加载中");
        UITableView *leftTableView  = input[0];
        UITableView *rightTableView = input[1];
        RACSignal *signal   = [WTKRequestManager postArrayDataWithURL:@"CategoryAllGoods" withpramater:@{}];
        [signal subscribeNext:^(id x) {
            NSLog(@"%@",x);
            NSArray *array  = x;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                if (![self.dataDic valueForKey:obj[@"category_name"]])
                {
                    NSMutableArray *mArray = [NSMutableArray array];
                    WTKGood *good = [[WTKGood alloc]initWithDic:obj];
                    [mArray addObject:good];
                    self.dataDic[obj[@"category_name"]] = mArray;
                }
                else
                {
                    NSMutableArray *mArray = self.dataDic[obj[@"category_name"]];
                    WTKGood *good = [[WTKGood alloc]initWithDic:obj];
                    [mArray addObject:good];
                }
            }];
            self.leftArray = [self.dataDic allKeys];
            [leftTableView reloadData];
            [rightTableView reloadData];
            [SVProgressHUD dismiss];
        }];
        return signal;
    }];
    
    self.leftClickCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UITableView *tableView = input[0];
        NSIndexPath *indexPath = input[1];
        
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
        return [RACSignal empty];
    }];
    
    self.goodCommand        = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:nil params:@{@"title":@"商品详情"}];
        viewModel.goods = (WTKGood *)input;
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.rightCommand       = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    self.selectedCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
       return [RACSignal empty];
    }];
}

- (void)beginShowAnimation
{
    
}
- (void)beginDismissAnimation
{
    
}

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic)
    {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (NSArray *)leftArray
{
    if (!_leftArray)
    {
        _leftArray = [NSArray array];
    }
    return _leftArray;
}

@end
