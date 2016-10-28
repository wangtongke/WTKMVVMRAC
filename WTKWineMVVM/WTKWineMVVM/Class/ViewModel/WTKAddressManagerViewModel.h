//
//  WTKAddressManagerViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/25.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKAddressManagerViewModel : WTKBasedViewModel
///新建地址
@property(nonatomic,strong)RACCommand       *addAddressCommand;
///编辑地址
@property(nonatomic,strong)RACCommand       *editAddress;

///删除
@property(nonatomic,strong)RACCommand       *deleteAddress;

///判断是否从购物车进来
@property(nonatomic,assign)BOOL             isShoppingCar;

///点击cell
@property(nonatomic,strong)RACCommand       *cellClickCommand;


@end
