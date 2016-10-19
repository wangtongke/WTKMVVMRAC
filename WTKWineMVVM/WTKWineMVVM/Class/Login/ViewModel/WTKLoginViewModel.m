//
//  WTKLoginViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKLoginViewModel.h"

@interface WTKLoginViewModel ()

@property(nonatomic,assign)NSInteger code;

@property(nonatomic,assign)NSInteger time;

@end

@implementation WTKLoginViewModel
- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:service params:params];
    if (self)
    {
        [self initViewModel];
        self.code = 1234;
    }
    return self;
}

- (void)initViewModel
{

    @weakify(self);
    RACSignal *phoneSignal      = [RACObserve(self, phoneNum) map:^id(id value) {
        @strongify(self);
        return @([self isPhoneNum:value]);
    }];
    RACSignal *codeSignal       = [RACObserve(self, codeNum) map:^id(id value) {
        @strongify(self);
        return @([self isCodeNum:value]);
    }];
    
    self.canLoginSignal         = [RACSignal combineLatest:@[phoneSignal,codeSignal]
                                                    reduce:^id(NSNumber *phone,NSNumber *code){
        return @([phone boolValue] && [code boolValue]);
    }];
    
    self.canCodeSignal          = [RACSignal combineLatest:@[phoneSignal]
                                                    reduce:^id(NSNumber *phone){
        return @([phone boolValue]);
    }];
    
    
    self.codeCommand            = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        UIButton *btn           = input;
        btn.enabled             = NO;
        self.time               = 60;
        [btn setTitle:[NSString stringWithFormat:@"%ld",self.time] forState:UIControlStateNormal];
       __block NSTimer *timer   = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeTime:) userInfo:btn repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [timer invalidate];
            timer               = nil;
            btn.enabled         = YES;
            [btn setTitle:@"验证" forState:UIControlStateNormal];
        });
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random() % 12 / 15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SHOW_SUCCESS(@"发送成功");
            DISMISS_SVP(1.2);
            
        });
        
        
        return [RACSignal empty];
    }];
    
    self.loginCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [WTKTool login];
        CURRENT_USER.phoneNum   = self.phoneNum;
        [WTKDataManager saveUserData];
        SHOW_SUCCESS(@"登录成功");
        DISMISS_SVP(1);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@{@"code":@100}];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号被销毁");
            }];
        }];
    }];
    
}

- (void)updateCodeTime:(NSTimer *)timer
{
    UIButton *btn = timer.userInfo;
    self.time--;
    [btn setTitle:[NSString stringWithFormat:@"%ld",self.time] forState:UIControlStateNormal];
}

- (BOOL)isPhoneNum:(NSString *)phoneNum
{
    if ([phoneNum hasPrefix:@"1"])
    {
        return phoneNum.length == 13;
    }
    return NO;
}

- (BOOL)isCodeNum:(NSString *)code
{
    return [code integerValue] == self.code;
}

@end
