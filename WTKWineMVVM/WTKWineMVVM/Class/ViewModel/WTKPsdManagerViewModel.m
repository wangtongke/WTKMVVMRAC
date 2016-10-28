//
//  WTKPsdManagerViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/17.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKPsdManagerViewModel.h"

@interface WTKPsdManagerViewModel ()

@property(nonatomic,strong)RACSignal *signal2;

@end

@implementation WTKPsdManagerViewModel

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
    RACSignal *originSignal         = [RACObserve(self, w_originPsd)
                                       map:^id(id value) {
        @strongify(self);
        return @([self isPsd:value]);
    }];
    RACSignal *newSignal            = [RACObserve(self, w_newPsd)
                                       map:^id(id value) {
        return value;
    }];
    RACSignal *confirmSignal        = [RACObserve(self, w_confirmPsd)
                                       map:^id(id value) {
        return value;
    }];

    RACSignal *enableSignal         = [RACSignal combineLatest:@[newSignal,confirmSignal] reduce:^id(NSString *newPsd,NSString *configmString){
        return @([newPsd isEqualToString:configmString] && newPsd.length == 6);
    }];
    
    self.canSignal                  = [RACSignal combineLatest:@[originSignal,enableSignal]
                                                        reduce:^id(NSNumber *origin,NSNumber *new){
                                        return @([origin boolValue] && [new boolValue]);
    }];
    
    
    self.confirmCommand             = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        SHOW_SVP(@"修改中");
        DISMISS_SVP(0.4)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            SHOW_SUCCESS(@"修改成功");
            DISMISS_SVP(1.2);
            [self.naviImpl popViewControllerWithAnimation:YES];
            CURRENT_USER.password = self.w_confirmPsd;
            [WTKDataManager saveUserData];
        });
        
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@{@"code":@100}];
//            [subscriber sendCompleted];
            return nil;
        }];
    }];
}
- (BOOL)isPsd:(NSString *)string
{
    if (string.length == 6)
    {
        return YES;
    }
    return NO;
}

@end
