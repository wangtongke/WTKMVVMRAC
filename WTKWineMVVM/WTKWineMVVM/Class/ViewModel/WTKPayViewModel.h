//
//  WTKPayViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/24.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKPayViewModel : WTKBasedViewModel
///本次买的商品
@property(nonatomic,strong)NSMutableArray   *goodsArray;
///总费用
@property(nonatomic,assign)CGFloat          price;

///确认付款
@property(nonatomic,strong)RACCommand       *payCommand;

///商品点击
@property(nonatomic,strong)RACCommand       *goodCommand;
@end
