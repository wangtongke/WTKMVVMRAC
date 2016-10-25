//
//  WTKPaySuccessViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/25.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"
@class WTKOrderModel;
@interface WTKPaySuccessViewModel : WTKBasedViewModel

@property(nonatomic,strong)WTKOrderModel    *orderModel;
///查看订单
@property(nonatomic,strong)RACCommand       *orderCommand;

///
@property(nonatomic,strong)RACCommand       *goHomeCommand;
@end
