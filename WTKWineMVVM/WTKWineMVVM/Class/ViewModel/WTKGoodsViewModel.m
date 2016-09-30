//
//  WTKGoodsViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/18.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKGoodsViewModel.h"
#import "WTKGood.h"
@implementation WTKGoodsViewModel

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
    
}

@end
