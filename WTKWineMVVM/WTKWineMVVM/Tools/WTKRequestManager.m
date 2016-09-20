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
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:urlString ofType:nil]];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:array];
        [subscriber sendCompleted];
        return nil;
    }]delay:1.5];
}

+ (RACSignal *)postDicDataWithURL:(NSString *)urlString
                     withpramater:(NSDictionary *)paremater
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:urlString ofType:nil]];
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:dic];
        [subscriber sendCompleted];
        return nil;
    }] delay:1.5];
}

@end
