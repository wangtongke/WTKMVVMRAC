//
//  WTKBasedViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/14.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
#import "WTKLoginViewModel.h"
@interface WTKBasedViewModel ()
@property(nonatomic,strong,readwrite)id<WTKViewModelServices> services;
@property (nonatomic, copy, readwrite) NSDictionary *params;
@end

@implementation WTKBasedViewModel
- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        self.title      = params[@"title"];
        self.params     = params;
        self.services   = service;
    }
    return self;
}

- (BOOL)judgeWhetherLogin:(BOOL)goLogin
{
    if ([WTKUser currentUser].isLogin)
    {
        return YES;
    }
    if (goLogin)
    {
        WTKLoginViewModel *viewModel    = [[WTKLoginViewModel alloc]initWithService:self.services params:@{@"title":@"登录"}];
        self.naviImpl.className         = @"WTKLoginVC";
        [self.naviImpl pushViewModel:viewModel animated:YES];
    }
    
//    GOlOGIN
    
    return NO;
    
}
@end
