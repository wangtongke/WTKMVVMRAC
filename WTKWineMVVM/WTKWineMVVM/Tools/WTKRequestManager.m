//
//  WTKRequestManager.m
//  ZHBMVVM
//
//  Created by 王同科 on 16/9/7.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKRequestManager.h"

@implementation WTKRequestManager


//+ (instancetype)shareManager
//{
//    static WTKRequestManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[WTKRequestManager alloc]init];
//    });
//    return manager;
//    
//}

+ (RACSignal *)postArrayDataWithURL:(NSString *)urlString
       withpramater:(NSDictionary *)paremater
{
    CGFloat time = arc4random()%15 / 10.0;
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:urlString ofType:nil]];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:array];
        [subscriber sendCompleted];
        return nil;
    }]delay:time];
#warning 以后修改delay
}

+ (RACSignal *)postDicDataWithURL:(NSString *)urlString
                     withpramater:(NSDictionary *)paremater
{
    CGFloat time = arc4random()%15 / 10.0;
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:urlString ofType:nil]];
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:dic];
        [subscriber sendCompleted];
        return nil;
    }] delay:time];
#warning 以后修改delay
}

+ (RACSignal *)getWithURL:(NSString *)urlString withParamater:(NSDictionary *)paramter
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    RACSubject *sub =[ RACSubject subject];
    [manager GET:urlString parameters:paramter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [sub sendNext:@{@"code":@100,@"data":responseObject}];
        [sub sendCompleted];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [sub sendNext:@{@"code":@-400,@"data":@"请求失败"}];
        [sub sendCompleted];
    }];
    return sub;
}

+ (RACSignal *)postWithURL:(NSString *)urlString withParamater:(NSDictionary *)parameter
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    RACSubject *sub =[ RACSubject subject];
    [manager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [sub sendNext:responseObject];
        [sub sendCompleted];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [sub sendNext:@{@"code":@-400}];
        [sub sendCompleted];
    }];
    
    return sub;
}

@end
