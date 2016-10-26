//
//  WTKNewAddressViewModel.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKBasedViewModel.h"

@interface WTKNewAddressViewModel : WTKBasedViewModel

@property(nonatomic,strong)WTKAddress       *address;
/// 保存
@property(nonatomic,strong)RACCommand       *saveCommand;
/// 选择地址
@property(nonatomic,strong)RACCommand       *addressCommand;

@end
