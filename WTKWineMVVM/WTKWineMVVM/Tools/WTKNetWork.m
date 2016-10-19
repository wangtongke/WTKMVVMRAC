//
//  WTKNetWork.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/19.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKNetWork.h"

//#import "Reachability.h"

@implementation WTKNetWork

+ (instancetype)shareInatance
{
    static WTKNetWork *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WTKNetWork alloc]init];
    });
    return manager;
}

- (void)initNetWork
{
    
}


@end
