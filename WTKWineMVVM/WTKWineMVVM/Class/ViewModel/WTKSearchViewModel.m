//
//  WTKSearchViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/31.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKSearchViewModel.h"
#import "WTKGoodsViewModel.h"
#import "WTKShoppingCarViewModel.h"

#define HISTORY @"historySearch"

@implementation WTKSearchViewModel

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
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SHOW_SVP(@"加载中");
        NSString *key = input;
        if ([USER_DEFAULTS valueForKey:HISTORY])
        {
            NSArray *array = [USER_DEFAULTS valueForKey:HISTORY];
            NSMutableArray *mArray = array.mutableCopy;
            if ([mArray indexOfObject:key] == NSNotFound)
            {
                [mArray addObject:input];
                [USER_DEFAULTS setValue:mArray forKey:HISTORY];
            }
        }
        else
        {
            NSMutableArray *array = @[key].mutableCopy;
            [USER_DEFAULTS setValue:array forKey:HISTORY];
        }
        if (![key isEqualToString:@"茅台"])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%15 / 10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SHOW_ERROE(@"暂时没有搜到商品");
                DISMISS_SVP(1.2);
            });

            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@[]];
                [subscriber sendCompleted];
                return nil;
            }];
        }
        RACSignal *signal = [WTKRequestManager postArrayDataWithURL:@"SearchResult" withpramater:nil];
        [signal subscribeNext:^(id x) {
            DISMISS_SVP(0.01);
        }];
        return signal;
    }];
    
    self.goodCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSLog(@"%@",input);
        WTKGoodsViewModel *viewModel = [[WTKGoodsViewModel alloc]initWithService:self.services params:@{@"title":@"商品详情"}];
        viewModel.goods = input;
        self.naviImpl.className = @"WTKGoodsVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.shoppingCarCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.naviImpl.selectedIndex = 3;
        [self.naviImpl popToRootViewModelWithAnimation:YES];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            return nil;
        }];
    }];
    
    self.deleteHistory = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [USER_DEFAULTS setValue:@[].mutableCopy forKey:HISTORY];
            [subject sendNext:@1];
            [subject sendCompleted];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.vc presentViewController:alert animated:YES completion:nil];
        
        return subject;
    }];
}

@end
